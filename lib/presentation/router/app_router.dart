/// GoRouter configuration for RentKhata.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/bill.dart';
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/language_selection_screen.dart';
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
import '../screens/auth/lock_screen.dart';
import '../screens/billing/bill_detail_screen.dart';
import '../widgets/main_shell.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

/// Route paths
class AppRoutes {
  static const String splash = '/';
  static const String language = '/language';
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
  static const String lock = '/lock';
}

// Navigation keys for shell routes
final rootNavigatorKey = GlobalKey<NavigatorState>();

CustomTransitionPage<void> _onboardingTransition(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionDuration: const Duration(milliseconds: 600),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0.05, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        ),
      );
    },
  );
}

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      // ========== Onboarding Routes (outside shell) ==========
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            _onboardingTransition(const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.language,
        pageBuilder: (context, state) =>
            _onboardingTransition(const LanguageSelectionScreen()),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        pageBuilder: (context, state) =>
            _onboardingTransition(const WelcomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        pageBuilder: (context, state) =>
            _onboardingTransition(const ProfileSetupScreen()),
      ),
      GoRoute(
        path: AppRoutes.addFirstProperty,
        pageBuilder: (context, state) =>
            _onboardingTransition(const AddFirstPropertyScreen()),
      ),

      // ========== Lock Screen (outside shell) ==========
      GoRoute(
        path: AppRoutes.lock,
        builder: (context, state) => const LockScreen(),
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

      // ========== Bill Detail (outside shell for full-screen) ==========
      GoRoute(
        path: AppRoutes.billPreview,
        builder: (context, state) {
          final bill = state.extra as Bill?;
          if (bill != null) {
            return BillDetailScreen(bill: bill);
          }
          // Fallback if accessed without extra (though our app always pushes extra)
          // Since BillDetailScreen requires a Bill, we throw or show an error
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.errorGeneric)),
            body: const Center(child: Text('Bill not found in navigation state')),
          );
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

          // Reports branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.reports,
                builder: (context, state) => const ReportsScreen(),
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
    ],
  );
});
