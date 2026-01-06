/// GoRouter configuration for RentKhata.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/onboarding/splash_screen.dart';

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

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // TODO: Add remaining routes as screens are implemented
    ],
  );
});
