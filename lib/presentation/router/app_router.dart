/// GoRouter configuration for RentKhata.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/bill.dart';
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/onboarding/profile_setup_screen.dart';
import '../screens/onboarding/add_first_property_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/properties/properties_screen.dart';
import '../screens/properties/add_property_screen.dart';
import '../screens/properties/property_detail_screen.dart';
import '../screens/rooms/room_detail_screen.dart';
import '../screens/tenants/tenants_screen.dart';
import '../screens/tenants/add_tenant_screen.dart';
import '../screens/tenants/tenant_detail_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/backup_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/occupancies/occupancy_detail_screen.dart';
import '../widgets/main_shell.dart';

/// Route paths
class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String profileSetup = '/profile-setup';
  static const String addFirstProperty = '/add-first-property';
  static const String dashboard = '/dashboard';
  static const String properties = '/properties';
  static const String propertyDetail = '/properties/:id';
  static const String addProperty = '/properties/add';
  static const String roomDetail = '/rooms/:id';
  static const String addRoom = '/properties/:propertyId/rooms/add';
  static const String tenants = '/tenants';
  static const String tenantDetail = '/tenants/:id';
  static const String addTenant = '/tenants/add';
  static const String createBill = '/rooms/:roomId/bills/create';
  static const String billPreview = '/bills/:id';
  static const String reports = '/reports';
  static const String occupancyDetail = '/occupancies/:id';
  static const String settings = '/settings';
  static const String backup = '/settings/backup';
}

// Navigation keys for shell routes
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      // ========== Onboarding Routes (outside shell) ==========
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.addFirstProperty,
        builder: (context, state) => const AddFirstPropertyScreen(),
      ),

      // ========== Room Detail (outside shell for full-screen) ==========
      GoRoute(
        path: AppRoutes.roomDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          // Parse query parameters for billing cycle integration
          final createBill = state.uri.queryParameters['createBill'] == 'true';
          final cycleStartStr = state.uri.queryParameters['cycleStart'];
          final cycleEndStr = state.uri.queryParameters['cycleEnd'];
          final billTypeStr = state.uri.queryParameters['billType'];

          DateTime? cycleStart;
          DateTime? cycleEnd;
          if (cycleStartStr != null) {
            cycleStart = DateTime.tryParse(cycleStartStr);
          }
          if (cycleEndStr != null) {
            cycleEnd = DateTime.tryParse(cycleEndStr);
          }

          // Parse bill type from query parameter
          BillType? billType;
          if (billTypeStr != null) {
            billType = BillType.values
                .where((e) => e.name == billTypeStr)
                .firstOrNull;
          }

          return RoomDetailScreen(
            roomId: id,
            createBill: createBill,
            cycleStart: cycleStart,
            cycleEnd: cycleEnd,
            billType: billType,
          );
        },
      ),

      // ========== Occupancy Detail (outside shell for full-screen) ==========
      GoRoute(
        path: AppRoutes.occupancyDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return OccupancyDetailScreen(occupancyId: id);
        },
      ),

      // ========== Main Shell with Bottom Navigation ==========
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // Properties branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.properties,
                builder: (context, state) => const PropertiesScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const AddPropertyScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return PropertyDetailScreen(propertyId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Tenants branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tenants,
                builder: (context, state) => const TenantsScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const AddTenantScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return TenantDetailScreen(tenantId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Settings branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'backup',
                    builder: (context, state) => const BackupScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ========== Modal Routes (outside shell) ==========
      GoRoute(
        path: AppRoutes.reports,
        builder: (context, state) => const ReportsScreen(),
      ),
    ],
  );
});
