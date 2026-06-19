import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/review_service.dart';

/// Provider for ReviewService
final reviewServiceProvider = Provider<ReviewService>((ref) {
  return ReviewService();
});
