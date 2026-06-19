import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// A wrapper around Firebase Analytics to log meaningful custom events.
class AnalyticsService {
  FirebaseAnalytics? get _analytics {
    if (Firebase.apps.isEmpty) return null;
    return FirebaseAnalytics.instance;
  }

  Future<void> _safeLog(String label, Future<void> Function(FirebaseAnalytics) action) async {
    try {
      final analytics = _analytics;
      if (analytics == null) return;
      await action(analytics);
    } catch (error, stackTrace) {
      debugPrint('Analytics log failed for $label: $error');
      try {
        if (Firebase.apps.isNotEmpty) {
          await FirebaseCrashlytics.instance.recordError(
            error,
            stackTrace,
            reason: 'Analytics log failed for $label',
            fatal: false,
          );
        }
      } catch (_) {}
    }
  }

  /// Call this when a new tenant is successfully created
  Future<void> logTenantCreated() async {
    await _safeLog('tenant_created', (analytics) {
      return analytics.logEvent(name: 'tenant_created');
    });
  }

  /// Call this when a new bill is successfully generated
  Future<void> logBillGenerated({required double amount}) async {
    await _safeLog('bill_generated', (analytics) {
      return analytics.logEvent(
        name: 'bill_generated',
        parameters: {'amount': amount},
      );
    });
  }

  /// Call this when a payment is recorded
  Future<void> logPaymentRecorded({required double amount, required String method}) async {
    await _safeLog('payment_recorded', (analytics) {
      return analytics.logEvent(
        name: 'payment_recorded',
        parameters: {'amount': amount, 'method': method},
      );
    });
  }

  /// Call this when the user completes onboarding
  Future<void> logOnboardingCompleted() async {
    await _safeLog('onboarding_completed', (analytics) {
      return analytics.logEvent(name: 'onboarding_completed');
    });
  }

  /// Call this when the user shares the app or uses a share functionality
  Future<void> logAppShared() async {
    await _safeLog('app_shared', (analytics) {
      return analytics.logShare(
        contentType: 'app_link',
        itemId: 'rent_khata',
        method: 'system_share',
      );
    });
  }

  // ==========================================
  // In-App Review Marketing Funnel Tracking
  // ==========================================

  /// Call this when the review prompt dialog is shown to the user
  Future<void> logReviewPromptShown({required String context}) async {
    await _safeLog('review_prompt_shown', (analytics) {
      return analytics.logEvent(
        name: 'review_prompt_shown',
        parameters: {'trigger_context': context},
      );
    });
  }

  /// Call this when the user clicks 'Rate 5 Stars'
  Future<void> logReviewPromptRateClicked({required String context}) async {
    await _safeLog('review_prompt_rate_clicked', (analytics) {
      return analytics.logEvent(
        name: 'review_prompt_rate_clicked',
        parameters: {'trigger_context': context},
      );
    });
  }

  /// Call this when the user clicks 'I have a suggestion' (Negative review trapped)
  Future<void> logReviewPromptSuggestionClicked({required String context}) async {
    await _safeLog('review_prompt_suggestion_clicked', (analytics) {
      return analytics.logEvent(
        name: 'review_prompt_suggestion_clicked',
        parameters: {'trigger_context': context},
      );
    });
  }

  /// Call this when the user dismisses the dialog via 'X' without taking action
  Future<void> logReviewPromptDismissed({required String context}) async {
    await _safeLog('review_prompt_dismissed', (analytics) {
      return analytics.logEvent(
        name: 'review_prompt_dismissed',
        parameters: {'trigger_context': context},
      );
    });
  }
}
