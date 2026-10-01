import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Holds the strokes drawn on a [SignaturePad] and can export them as a PNG.
class SignatureController extends ChangeNotifier {
  final List<List<Offset>> _strokes = <List<Offset>>[];
  Size _size = Size.zero;

  bool get isEmpty => _strokes.isEmpty;

  void _start(Offset p) {
    _strokes.add(<Offset>[p]);
    notifyListeners();
  }

  void _add(Offset p) {
    if (_strokes.isEmpty) return;
    _strokes.last.add(p);
    notifyListeners();
  }

  void clear() {
    _strokes.clear();
    notifyListeners();
  }

  void _paintStrokes(Canvas canvas, Color ink) {
    final Paint line = Paint()
      ..color = ink
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final Paint dot = Paint()..color = ink;
    for (final List<Offset> stroke in _strokes) {
      if (stroke.length == 1) {
        canvas.drawCircle(stroke.first, 1, dot);
        continue;
      }
      final Path path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final Offset p in stroke.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, line);
    }
  }

  /// Renders the signature (black ink, transparent background) to PNG bytes.
  /// Returns null when nothing has been drawn.
  Future<Uint8List?> toPngBytes({double pixelRatio = 2}) async {
    if (_strokes.isEmpty || _size.isEmpty) return null;
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    canvas.scale(pixelRatio);
    _paintStrokes(canvas, Colors.black);
    final ui.Picture picture = recorder.endRecording();
    final ui.Image image = await picture.toImage(
      (_size.width * pixelRatio).round(),
      (_size.height * pixelRatio).round(),
    );
    final ByteData? data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }
}

/// Finger / stylus drawing surface. Claims pointer events immediately so a parent
/// scroll view or dialog doesn't steal the drag.
class SignaturePad extends StatelessWidget {
  const SignaturePad({
    super.key,
    required this.controller,
    this.height = 200,
    this.inkColor = Colors.black,
  });

  final SignatureController controller;
  final double height;
  final Color inkColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          controller._size = Size(constraints.maxWidth, height);
          return RawGestureDetector(
            gestures: <Type, GestureRecognizerFactory>{
              EagerGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<EagerGestureRecognizer>(
                () => EagerGestureRecognizer(),
                (EagerGestureRecognizer instance) {},
              ),
            },
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (PointerDownEvent e) => controller._start(e.localPosition),
              onPointerMove: (PointerMoveEvent e) => controller._add(e.localPosition),
              child: RepaintBoundary(
                child: CustomPaint(
                  size: Size(constraints.maxWidth, height),
                  painter: _SignaturePainter(controller, inkColor),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter(this.controller, this.ink) : super(repaint: controller);

  final SignatureController controller;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    controller._paintStrokes(canvas, ink);
  }

  @override
  bool shouldRepaint(_SignaturePainter old) =>
      old.controller != controller || old.ink != ink;
}
