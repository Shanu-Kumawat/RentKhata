import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../services/analytics_service.dart';

/// Provider for AnalyticsService
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

final firebaseAnalyticsObserverProvider = Provider<FirebaseAnalyticsObserver?>((
  ref,
) {
  if (Firebase.apps.isEmpty) return null;
  return FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
});
