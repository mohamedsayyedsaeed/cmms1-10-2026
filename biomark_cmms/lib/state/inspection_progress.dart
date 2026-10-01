import 'package:flutter/foundation.dart';

/// Tracks which equipment has been inspected, per inspection task.
/// (The prototype kept an always-empty list here with a comment saying
/// "in real app, this would come from API/state".)
class InspectionProgress extends ChangeNotifier {
  final Map<String, Set<String>> _completed = <String, Set<String>>{};

  Set<String> completedFor(String inspectionId) =>
      _completed[inspectionId] ?? const <String>{};

  bool isCompleted(String inspectionId, String equipmentId) =>
      completedFor(inspectionId).contains(equipmentId);

  void markCompleted(String inspectionId, String equipmentId) {
    _completed.putIfAbsent(inspectionId, () => <String>{}).add(equipmentId);
    notifyListeners();
  }
}
