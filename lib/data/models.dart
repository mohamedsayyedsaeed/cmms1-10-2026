// Dart equivalents of src/types/index.ts (plus a few page-local types the
// prototype declared inline in its screens).

enum WorkOrderPriority {
  low('low'),
  medium('medium'),
  high('high'),
  critical('critical');

  const WorkOrderPriority(this.label);
  final String label;
}

enum WorkOrderStatus {
  assigned('assigned'),
  inProgress('in-progress'),
  completed('completed'),
  cancelled('cancelled');

  const WorkOrderStatus(this.label);
  final String label;
}

enum RiskScore {
  low('low'),
  medium('medium'),
  high('high');

  const RiskScore(this.label);
  final String label;
}

enum AssetStatus {
  operational('operational'),
  maintenance('maintenance'),
  outOfService('out-of-service');

  const AssetStatus(this.label);
  final String label;
}

/// `name` doubles as the translation key ('preventive', 'corrective', ...).
enum MaintenanceType { preventive, corrective, calibration }

enum StockStatus {
  inStock('in-stock'),
  lowStock('low-stock'),
  outOfStock('out-of-stock');

  const StockStatus(this.label);
  final String label;
}

enum NotificationType { alert, assignment, update }

enum Trend { up, down, stable }

class MaintenanceStep {
  MaintenanceStep({
    required this.id,
    required this.description,
    required this.completed,
    this.completedAt,
  });

  final String id;
  final String description;
  bool completed;
  final DateTime? completedAt;
}

class WorkOrder {
  WorkOrder({
    required this.id,
    required this.assetName,
    required this.assetId,
    required this.location,
    required this.priority,
    required this.status,
    required this.assignedTo,
    required this.createdAt,
    required this.dueDate,
    required this.description,
    required this.steps,
    required this.photos,
  });

  final String id;
  final String assetName;
  final String assetId;
  final String location;
  final WorkOrderPriority priority;
  final WorkOrderStatus status;
  final String assignedTo;
  final DateTime createdAt;
  final DateTime dueDate;
  final String description;
  final List<MaintenanceStep> steps;
  final List<String> photos;
}

class MaintenanceRecord {
  const MaintenanceRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.technician,
    required this.description,
    required this.duration,
  });

  final String id;
  final DateTime date;
  final MaintenanceType type;
  final String technician;
  final String description;

  /// Minutes.
  final int duration;
}

class Asset {
  const Asset({
    required this.id,
    required this.name,
    required this.model,
    required this.serialNumber,
    required this.location,
    required this.department,
    required this.riskScore,
    required this.status,
    required this.lastMaintenance,
    required this.nextPPM,
    required this.maintenanceHistory,
  });

  final String id;
  final String name;
  final String model;
  final String serialNumber;
  final String location;
  final String department;
  final RiskScore riskScore;
  final AssetStatus status;
  final DateTime lastMaintenance;
  final DateTime nextPPM;
  final List<MaintenanceRecord> maintenanceHistory;
}

class SparePart {
  const SparePart({
    required this.id,
    required this.name,
    required this.partNumber,
    required this.stockLevel,
    required this.minStock,
    required this.location,
    required this.unitPrice,
    required this.status,
  });

  final String id;
  final String name;
  final String partNumber;
  final int stockLevel;
  final int minStock;
  final String location;
  final double unitPrice;
  final StockStatus status;
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool read;
}

class Kpi {
  const Kpi({
    required this.label,
    required this.value,
    this.change,
    this.trend,
  });

  final String label;
  final String value;
  final double? change;
  final Trend? trend;
}

// ---------------------------------------------------------------------------
// Types the prototype declared inside individual pages
// ---------------------------------------------------------------------------

class InspectionTask {
  const InspectionTask({
    required this.id,
    required this.taskNumber,
    required this.location,
    required this.startDate,
    required this.dueDate,
    required this.isOverdue,
  });

  final String id;
  final String taskNumber;
  final String location;
  final DateTime startDate;
  final DateTime dueDate;
  final bool isOverdue;
}

class Equipment {
  const Equipment({
    required this.id,
    required this.name,
    required this.code,
    required this.serialNumber,
    required this.model,
    required this.location,
  });

  final String id;
  final String name;
  final String code;
  final String serialNumber;
  final String model;
  final String location;
}

class InspectionDetail {
  const InspectionDetail({
    required this.id,
    required this.taskNumber,
    required this.location,
    required this.startDate,
    required this.dueDate,
    required this.isOverdue,
    required this.description,
    required this.priority,
    required this.assignedTo,
    required this.createdDate,
    required this.estimatedDuration,
    required this.status,
    required this.equipment,
  });

  final String id;
  final String taskNumber;
  final String location;
  final DateTime startDate;
  final DateTime dueDate;
  final bool isOverdue;
  final String description;

  /// 'critical' | 'high' | 'medium' | 'low' (also the translation key)
  final String priority;
  final String assignedTo;
  final DateTime createdDate;

  /// Hours.
  final int estimatedDuration;

  /// 'pending' | 'in-progress' | 'completed'
  final String status;
  final List<Equipment> equipment;
}

class PmTask {
  const PmTask({
    required this.id,
    required this.taskNumber,
    required this.deviceName,
    required this.deviceCode,
    required this.location,
    required this.startDate,
    required this.dueDate,
    required this.isOverdue,
  });

  final String id;
  final String taskNumber;
  final String deviceName;
  final String deviceCode;
  final String location;
  final DateTime startDate;
  final DateTime dueDate;
  final bool isOverdue;
}

/// A pass / fail checklist row (inspection steps and PM checklist).
/// `result`: true = pass, false = fail, null = not checked.
class ChecklistItem {
  ChecklistItem(this.id, this.description, {this.result});

  final String id;
  final String description;
  bool? result;
}

class InstalledAsset {
  const InstalledAsset({
    required this.id,
    required this.name,
    required this.location,
    required this.installedDate,
  });

  final String id;
  final String name;
  final String location;
  final DateTime installedDate;
}

class CompletionRecord {
  const CompletionRecord({
    required this.id,
    required this.asset,
    required this.date,
    required this.duration,
  });

  final String id;
  final String asset;
  final String date;
  final String duration;
}
