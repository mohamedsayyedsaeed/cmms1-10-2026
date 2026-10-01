// GENERATED from src/utils/mockData.ts — do not edit by hand.
import 'models.dart';

final List<WorkOrder> mockWorkOrders = [
  WorkOrder(
    id: 'WO-2024-001',
    assetName: 'Ventilator - Model V300',
    assetId: 'AST-001',
    location: 'ICU - Room 204',
    priority: WorkOrderPriority.critical,
    status: WorkOrderStatus.inProgress,
    assignedTo: 'Ahmed Hassan',
    createdAt: DateTime.parse('2024-01-15T08:00:00Z'),
    dueDate: DateTime.parse('2024-01-15T16:00:00Z'),
    description: 'Pressure sensor malfunction - requires immediate attention',
    steps: [
      MaintenanceStep(id: '1', description: 'Inspect pressure sensor connections', completed: true, completedAt: DateTime.parse('2024-01-15T09:00:00Z')),
      MaintenanceStep(id: '2', description: 'Test sensor calibration', completed: true, completedAt: DateTime.parse('2024-01-15T09:30:00Z')),
      MaintenanceStep(id: '3', description: 'Replace sensor if needed', completed: false),
      MaintenanceStep(id: '4', description: 'Run full system diagnostics', completed: false),
    ],
    photos: [],
  ),
  WorkOrder(
    id: 'WO-2024-002',
    assetName: 'Patient Monitor - PM500',
    assetId: 'AST-002',
    location: 'ER - Station 3',
    priority: WorkOrderPriority.high,
    status: WorkOrderStatus.assigned,
    assignedTo: 'Ahmed Hassan',
    createdAt: DateTime.parse('2024-01-15T10:00:00Z'),
    dueDate: DateTime.parse('2024-01-16T10:00:00Z'),
    description: 'Display flickering intermittently',
    steps: [
      MaintenanceStep(id: '1', description: 'Check display cable connections', completed: false),
      MaintenanceStep(id: '2', description: 'Update firmware', completed: false),
      MaintenanceStep(id: '3', description: 'Test display functionality', completed: false),
    ],
    photos: [],
  ),
];

final List<Asset> mockAssets = [
  Asset(
    id: 'AST-001',
    name: 'Ventilator - Model V300',
    model: 'V300',
    serialNumber: 'VNT-2023-001',
    location: 'ICU - Room 204',
    department: 'Intensive Care',
    riskScore: RiskScore.high,
    status: AssetStatus.maintenance,
    lastMaintenance: DateTime.parse('2024-01-10'),
    nextPPM: DateTime.parse('2024-02-10'),
    maintenanceHistory: [
      MaintenanceRecord(id: '1', date: DateTime.parse('2024-01-10'), type: MaintenanceType.preventive, technician: 'Ahmed Hassan', description: 'Routine PPM - Filter replacement and calibration', duration: 120),
      MaintenanceRecord(id: '2', date: DateTime.parse('2023-12-15'), type: MaintenanceType.corrective, technician: 'Sarah Ahmed', description: 'Alarm system repair', duration: 90),
      MaintenanceRecord(id: '3', date: DateTime.parse('2023-11-20'), type: MaintenanceType.calibration, technician: 'Mohammed Ali', description: 'Annual calibration - Pressure and flow sensors', duration: 150),
      MaintenanceRecord(id: '4', date: DateTime.parse('2023-10-05'), type: MaintenanceType.corrective, technician: 'Ahmed Hassan', description: 'Power supply unit replacement', duration: 180),
      MaintenanceRecord(id: '5', date: DateTime.parse('2023-09-12'), type: MaintenanceType.preventive, technician: 'Fatima Khan', description: 'Quarterly PPM - System check and cleaning', duration: 90),
      MaintenanceRecord(id: '6', date: DateTime.parse('2023-08-18'), type: MaintenanceType.calibration, technician: 'Mohammed Ali', description: 'Oxygen sensor calibration', duration: 60),
      MaintenanceRecord(id: '7', date: DateTime.parse('2023-07-22'), type: MaintenanceType.corrective, technician: 'Sarah Ahmed', description: 'Display screen replacement', duration: 120),
      MaintenanceRecord(id: '8', date: DateTime.parse('2023-06-10'), type: MaintenanceType.preventive, technician: 'Ahmed Hassan', description: 'Semi-annual PPM - Full system inspection', duration: 150),
    ],
  ),
  Asset(
    id: 'AST-002',
    name: 'Patient Monitor - PM500',
    model: 'PM500',
    serialNumber: 'PM-2023-045',
    location: 'ER - Station 3',
    department: 'Emergency',
    riskScore: RiskScore.medium,
    status: AssetStatus.operational,
    lastMaintenance: DateTime.parse('2024-01-05'),
    nextPPM: DateTime.parse('2024-04-05'),
    maintenanceHistory: [
      MaintenanceRecord(id: '1', date: DateTime.parse('2024-01-05'), type: MaintenanceType.preventive, technician: 'Ahmed Hassan', description: 'Quarterly PPM - Sensor calibration', duration: 60),
      MaintenanceRecord(id: '2', date: DateTime.parse('2023-11-28'), type: MaintenanceType.corrective, technician: 'Fatima Khan', description: 'ECG lead cable replacement', duration: 45),
      MaintenanceRecord(id: '3', date: DateTime.parse('2023-10-15'), type: MaintenanceType.calibration, technician: 'Mohammed Ali', description: 'Blood pressure sensor calibration', duration: 75),
      MaintenanceRecord(id: '4', date: DateTime.parse('2023-09-08'), type: MaintenanceType.preventive, technician: 'Sarah Ahmed', description: 'Routine maintenance and cleaning', duration: 60),
      MaintenanceRecord(id: '5', date: DateTime.parse('2023-07-20'), type: MaintenanceType.corrective, technician: 'Ahmed Hassan', description: 'Battery replacement', duration: 30),
      MaintenanceRecord(id: '6', date: DateTime.parse('2023-06-12'), type: MaintenanceType.calibration, technician: 'Mohammed Ali', description: 'Temperature probe calibration', duration: 45),
    ],
  ),
];

final List<SparePart> mockSpareParts = [
  const SparePart(id: 'SP-001', name: 'Pressure Sensor - V300', partNumber: 'PS-V300-001', stockLevel: 3, minStock: 5, location: 'Storage - Shelf A3', unitPrice: 450.0, status: StockStatus.lowStock),
  const SparePart(id: 'SP-002', name: 'ECG Cable Set', partNumber: 'ECG-CBL-STD', stockLevel: 15, minStock: 10, location: 'Storage - Shelf B1', unitPrice: 120.0, status: StockStatus.inStock),
  const SparePart(id: 'SP-003', name: 'HEPA Filter - V300', partNumber: 'HEPA-V300', stockLevel: 0, minStock: 3, location: 'Storage - Shelf A2', unitPrice: 280.0, status: StockStatus.outOfStock),
];

final List<AppNotification> mockNotifications = [
  AppNotification(id: '1', type: NotificationType.alert, title: 'Critical Work Order', message: 'WO-2024-001 requires immediate attention - ICU Ventilator', timestamp: DateTime.parse('2024-01-15T08:00:00Z'), read: false),
  AppNotification(id: '2', type: NotificationType.assignment, title: 'New Work Order Assigned', message: 'WO-2024-002 has been assigned to you', timestamp: DateTime.parse('2024-01-15T10:00:00Z'), read: false),
  AppNotification(id: '3', type: NotificationType.update, title: 'PPM Schedule Updated', message: '5 assets require preventive maintenance this week', timestamp: DateTime.parse('2024-01-14T14:00:00Z'), read: true),
];

final List<Kpi> mockKpis = [
  const Kpi(label: 'Completion Rate', value: '94%', change: 2.0, trend: Trend.up),
  const Kpi(label: 'Avg Response Time', value: '2.3h', change: -0.5, trend: Trend.down),
  const Kpi(label: 'Overdue WOs', value: '3', change: -2.0, trend: Trend.down),
  const Kpi(label: 'Assets at Risk', value: '7', change: 1.0, trend: Trend.up),
];
