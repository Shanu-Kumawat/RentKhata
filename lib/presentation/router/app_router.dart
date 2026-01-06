/// GoRouter configuration for RentKhata.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/onboarding/splash_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/placeholder_screens.dart';
import '../widgets/main_shell.dart';

/// Route paths
class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String profileSetup = '/profile-setup';
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
  static const String settings = '/settings';
  static const String backup = '/settings/backup';
}

// Navigation keys for shell routes
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      // Splash screen (outside shell)
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Main shell with bottom navigation
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
                    builder: (context, state) => const PlaceholderScreen(
                      title: 'Add Property',
                      icon: Icons.add_home_work_outlined,
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      return const PlaceholderScreen(
                        title: 'Property Details',
                        icon: Icons.home_work_outlined,
                      );
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
                    builder: (context, state) => const PlaceholderScreen(
                      title: 'Add Tenant',
                      icon: Icons.person_add_outlined,
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      return const PlaceholderScreen(
                        title: 'Tenant Details',
                        icon: Icons.person_outline,
                      );
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
                    builder: (context, state) => const PlaceholderScreen(
                      title: 'Backup & Restore',
                      icon: Icons.backup_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Reports (outside shell, modal-style)
      GoRoute(
        path: AppRoutes.reports,
        builder: (context, state) => const ReportsScreen(),
      ),
    ],
  );
});
