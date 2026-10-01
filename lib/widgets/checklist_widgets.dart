import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/context_ext.dart';
import '../core/theme/tone.dart';
import '../core/theme/tw_colors.dart';
import '../data/models.dart';
import 'app_card.dart';
import 'tone_boxes.dart';

/// Stand-in image used by the prototype's "add photo" simulation.
/// Replace with `image_picker` (camera / gallery) in a real build.
const String kSamplePhotoUrl =
    'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=400&q=80';
const String kSampleDevicePhotoUrl =
    'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800&q=80';

/// Network image that degrades to a neutral placeholder when offline.
class SafeNetworkImage extends StatelessWidget {
  const SafeNetworkImage(this.url, {super.key, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final Widget placeholder = Container(
      color: dark ? Tw.gray.shade800 : Tw.gray.shade200,
      alignment: Alignment.center,
      child: Icon(AppIcons.image, color: Tw.gray.shade400, size: 28),
    );
    return Image.network(
      url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (BuildContext c, Object e, StackTrace? s) => placeholder,
      loadingBuilder: (BuildContext c, Widget child, ImageChunkEvent? p) =>
          p == null ? child : placeholder,
    );
  }
}

/// Thin progress bar (`h-2 rounded-full`), filling from the leading edge.
class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.fraction, required this.gradient});

  final double fraction;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 8,
        color: dark ? Tw.gray.shade700 : Tw.gray.shade200,
        alignment: AlignmentDirectional.centerStart,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints c) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: c.maxWidth * fraction.clamp(0.0, 1.0),
              decoration: BoxDecoration(gradient: gradient),
            );
          },
        ),
      ),
    );
  }
}

/// Numbered pass/fail step (inspection steps and the PM checklist).
class ChecklistStepTile extends StatelessWidget {
  const ChecklistStepTile({
    super.key,
    required this.index,
    required this.item,
    required this.passLabel,
    required this.failLabel,
    required this.onChanged,
    this.disabled = false,
  });

  final int index;
  final ChecklistItem item;
  final String passLabel;
  final String failLabel;
  final ValueChanged<bool> onChanged;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    Color bg;
    Color border;
    if (item.result == true) {
      bg = Tone.green.softBg(dark);
      border = Tone.green.border(dark);
    } else if (item.result == false) {
      bg = Tone.red.softBg(dark);
      border = Tone.red.border(dark);
    } else {
      bg = context.tileBg;
      border = context.borderColor;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: context.cardBg,
              shape: BoxShape.circle,
              border: Border.all(
                color: dark ? Tw.gray.shade600 : Tw.gray.shade300,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: context.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Opacity(
                  opacity: disabled ? 0.5 : 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _ResultButton(
                          label: passLabel,
                          icon: AppIcons.check,
                          tone: Tone.green,
                          selected: item.result == true,
                          onTap: disabled ? null : () => onChanged(true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ResultButton(
                          label: failLabel,
                          icon: AppIcons.x,
                          tone: Tone.red,
                          selected: item.result == false,
                          onTap: disabled ? null : () => onChanged(false),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultButton extends StatelessWidget {
  const _ResultButton({
    required this.label,
    required this.icon,
    required this.tone,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Tone tone;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final Color fg = selected
        ? Colors.white
        : (dark ? Tw.gray.shade300 : Tw.gray.shade700);
    return Container(
      decoration: BoxDecoration(
        color: selected ? tone.c.shade500 : context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: selected
            ? null
            : Border.all(
                color: dark ? Tw.gray.shade700 : Tw.gray.shade200,
                width: 2,
              ),
        boxShadow: selected
            ? <BoxShadow>[
                BoxShadow(
                  color: tone.glow,
                  blurRadius: 15,
                  spreadRadius: -3,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: selected ? 10 : 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Rounded dashed outline (Flutter has no built-in dashed border).
class DashedBox extends StatelessWidget {
  const DashedBox({
    super.key,
    required this.child,
    required this.color,
    this.radius = 12,
    this.onTap,
  });

  final Widget child;
  final Color color;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedRRectPainter(color: color, radius: radius),
        child: child,
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 2;
    const double dash = 6;
    const double gap = 4;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    ).deflate(strokeWidth / 2);
    final Path path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter old) =>
      old.color != color || old.radius != radius;
}

/// "Attach images" card shared by the equipment inspection and PM screens.
class PhotoAttachCard extends StatelessWidget {
  const PhotoAttachCard({
    super.key,
    required this.photos,
    required this.onAdd,
    required this.onRemove,
    required this.readOnly,
  });

  final List<String> photos;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;
    final String subtitle = photos.isEmpty
        ? context.t('noPhotos')
        : '${photos.length} ${photos.length == 1 ? context.t('photoAttached') : context.t('photosAttached')}';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SectionHeader(
            icon: AppIcons.camera,
            tone: Tone.orange,
            title: context.t('attachImages'),
            subtitle: subtitle,
          ),
          const SizedBox(height: 16),
          if (photos.isNotEmpty) ...<Widget>[
            GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List<Widget>.generate(photos.length, (int i) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      SafeNetworkImage(photos[i]),
                      if (!readOnly)
                        PositionedDirectional(
                          top: 6,
                          end: 6,
                          child: GestureDetector(
                            onTap: () => onRemove(i),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Tw.red.shade500,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
          ],
          if (!readOnly)
            DashedBox(
              color: dark ? Tw.gray.shade700 : Tw.gray.shade300,
              onTap: onAdd,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Tone.orange.iconBg(dark),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        AppIcons.camera,
                        size: 24,
                        color: Tone.orange.iconFg(dark),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.t('addPhoto'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${context.t('takePhoto')} / ${context.t('chooseFromGallery')}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: context.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Brand progress gradient (inspection) — primary -> accent.
const LinearGradient kProgressBrand = LinearGradient(
  colors: <Color>[AppColors.primary, AppColors.accent],
);
