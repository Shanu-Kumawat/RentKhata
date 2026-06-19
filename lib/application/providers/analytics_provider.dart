import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/analytics_service.dart';

/// Provider for AnalyticsService
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
