import 'package:firebase_analytics/firebase_analytics.dart';

/// A wrapper around Firebase Analytics to log meaningful custom events.
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Call this when a new tenant is successfully created
  Future<void> logTenantCreated() async {
    await _analytics.logEvent(name: 'tenant_created');
  }

  /// Call this when a new bill is successfully generated
  Future<void> logBillGenerated({required double amount}) async {
    await _analytics.logEvent(
      name: 'bill_generated',
      parameters: {'amount': amount},
    );
  }

  /// Call this when a payment is recorded
  Future<void> logPaymentRecorded({required double amount, required String method}) async {
    await _analytics.logEvent(
      name: 'payment_recorded',
      parameters: {'amount': amount, 'method': method},
    );
  }

  /// Call this when the user completes onboarding
  Future<void> logOnboardingCompleted() async {
    await _analytics.logEvent(name: 'onboarding_completed');
  }

  /// Call this when the user shares the app or uses a share functionality
  Future<void> logAppShared() async {
    await _analytics.logShare(
      contentType: 'app_link',
      itemId: 'rent_khata',
      method: 'system_share',
    );
  }

  // ==========================================
  // In-App Review Marketing Funnel Tracking
  // ==========================================

  /// Call this when the review prompt dialog is shown to the user
  Future<void> logReviewPromptShown({required String context}) async {
    await _analytics.logEvent(
      name: 'review_prompt_shown',
      parameters: {'trigger_context': context},
    );
  }

  /// Call this when the user clicks 'Rate 5 Stars'
  Future<void> logReviewPromptRateClicked({required String context}) async {
    await _analytics.logEvent(
      name: 'review_prompt_rate_clicked',
      parameters: {'trigger_context': context},
    );
  }

  /// Call this when the user clicks 'I have a suggestion' (Negative review trapped)
  Future<void> logReviewPromptSuggestionClicked({required String context}) async {
    await _analytics.logEvent(
      name: 'review_prompt_suggestion_clicked',
      parameters: {'trigger_context': context},
    );
  }

  /// Call this when the user dismisses the dialog via 'X' without taking action
  Future<void> logReviewPromptDismissed({required String context}) async {
    await _analytics.logEvent(
      name: 'review_prompt_dismissed',
      parameters: {'trigger_context': context},
    );
  }
}
