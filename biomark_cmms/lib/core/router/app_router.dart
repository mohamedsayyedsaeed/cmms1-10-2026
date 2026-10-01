import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/asset_profile_page.dart';
import '../../screens/assets_page.dart';
import '../../screens/dashboard_page.dart';
import '../../screens/equipment_inspection_page.dart';
import '../../screens/inspection_detail_page.dart';
import '../../screens/inspections_page.dart';
import '../../screens/login_page.dart';
import '../../screens/maintenance_detail_page.dart';
import '../../screens/maintenance_history_page.dart';
import '../../screens/notifications_page.dart';
import '../../screens/pm_detail_page.dart';
import '../../screens/preventive_maintenance_page.dart';
import '../../screens/reports_page.dart';
import '../../screens/settings_page.dart';
import '../../screens/spare_parts_page.dart';
import '../../screens/splash_screen.dart';
import '../../screens/work_order_details_page.dart';
import '../../screens/work_orders_page.dart';
import '../../widgets/app_shell.dart';

/// Mirrors App.tsx: "/" splash and "/login" stand alone; everything else is
/// wrapped in AppShell (shared background + bottom nav + drawer) via ShellRoute.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (BuildContext context, GoRouterState state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (BuildContext context, GoRouterState state) => const LoginPage()),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AppShell(location: state.matchedLocation, child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/dashboard',
          builder: (BuildContext context, GoRouterState state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/work-orders',
          builder: (BuildContext context, GoRouterState state) => const WorkOrdersPage(),
        ),
        GoRoute(
          path: '/work-orders/:id',
          builder: (BuildContext context, GoRouterState state) =>
              WorkOrderDetailsPage(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/assets',
          builder: (BuildContext context, GoRouterState state) => const AssetsPage(),
        ),
        GoRoute(
          path: '/assets/:id',
          builder: (BuildContext context, GoRouterState state) =>
              AssetProfilePage(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/assets/:assetId/maintenance',
          builder: (BuildContext context, GoRouterState state) =>
              MaintenanceHistoryPage(assetId: state.pathParameters['assetId']!),
        ),
        GoRoute(
          path: '/assets/:assetId/maintenance/:maintenanceId',
          builder: (BuildContext context, GoRouterState state) => MaintenanceDetailPage(
            assetId: state.pathParameters['assetId']!,
            maintenanceId: state.pathParameters['maintenanceId']!,
          ),
        ),
        GoRoute(
          path: '/spare-parts',
          builder: (BuildContext context, GoRouterState state) => const SparePartsPage(),
        ),
        GoRoute(
          path: '/reports',
          builder: (BuildContext context, GoRouterState state) => const ReportsPage(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (BuildContext context, GoRouterState state) => const NotificationsPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/inspections',
          builder: (BuildContext context, GoRouterState state) => const InspectionsPage(),
        ),
        GoRoute(
          path: '/inspections/:id',
          builder: (BuildContext context, GoRouterState state) =>
              InspectionDetailPage(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/inspections/:inspectionId/equipment/:equipmentId',
          builder: (BuildContext context, GoRouterState state) => EquipmentInspectionPage(
            inspectionId: state.pathParameters['inspectionId']!,
            equipmentId: state.pathParameters['equipmentId']!,
            equipmentIds: (state.uri.queryParameters['equipment'] ?? '')
                .split(',')
                .where((String s) => s.isNotEmpty)
                .toList(),
          ),
        ),
        GoRoute(
          path: '/preventive-maintenance',
          builder: (BuildContext context, GoRouterState state) =>
              const PreventiveMaintenancePage(),
        ),
        GoRoute(
          path: '/preventive-maintenance/:id',
          builder: (BuildContext context, GoRouterState state) =>
              PmDetailPage(id: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);
