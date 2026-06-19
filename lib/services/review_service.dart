import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  final InAppReview _inAppReview = InAppReview.instance;

  static const _keyActionCount = 'review_action_count';
  static const _keyLastPromptDate = 'review_last_prompt_date';
  static const _keyHasClickedRate = 'review_has_clicked_rate';
  static const _keyDeclineCount = 'review_decline_count';

  /// Check if it's time to show the custom review prompt
  Future<bool> shouldShowReviewPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    
    final hasClickedRate = prefs.getBool(_keyHasClickedRate) ?? false;
    if (hasClickedRate) return false;

    final actionCount = prefs.getInt(_keyActionCount) ?? 0;
    final lastPromptDateStr = prefs.getString(_keyLastPromptDate);
    final declineCount = prefs.getInt(_keyDeclineCount) ?? 0;

    // First time logic: show immediately after 1 action
    if (lastPromptDateStr == null) {
      return actionCount >= 1;
    }

    // Progressive backoff logic
    final lastPromptDate = DateTime.parse(lastPromptDateStr);
    final daysSinceLastPrompt = DateTime.now().difference(lastPromptDate).inDays;

    if (declineCount == 1) {
      return daysSinceLastPrompt >= 7;
    } else if (declineCount == 2) {
      return daysSinceLastPrompt >= 14;
    } else {
      return daysSinceLastPrompt >= 30; // 3rd+ decline or suggestion given
    }
  }

  /// Record an action (like bill generated or payment recorded)
  Future<void> recordAction() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_keyActionCount) ?? 0;
    await prefs.setInt(_keyActionCount, currentCount + 1);
  }

  /// Record that we showed the prompt and the user declined (hit X)
  Future<void> recordDecline() async {
    final prefs = await SharedPreferences.getInstance();
    final declineCount = prefs.getInt(_keyDeclineCount) ?? 0;
    await prefs.setInt(_keyDeclineCount, declineCount + 1);
    await prefs.setString(_keyLastPromptDate, DateTime.now().toIso8601String());
  }

  /// Record that the user gave a suggestion (Google Form)
  Future<void> recordSuggestionGiven() async {
    final prefs = await SharedPreferences.getInstance();
    // Treat as a strong decline (wait 30 days) by forcing decline count to at least 3
    final declineCount = prefs.getInt(_keyDeclineCount) ?? 0;
    if (declineCount < 3) {
      await prefs.setInt(_keyDeclineCount, 3);
    }
    await prefs.setString(_keyLastPromptDate, DateTime.now().toIso8601String());
  }

  /// Call this when the user clicks "Rate 5 Stars"
  Future<void> triggerAppStoreReview() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasClickedRate, true);
    
    // Instead of native popup, forcefully open store listing
    await _inAppReview.openStoreListing(); 
  }
}
