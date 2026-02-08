/// Inactivity tracking service for app lock functionality.
library;

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Callback type for inactivity timeout.
typedef InactivityCallback = void Function();

/// Service to track user inactivity and trigger lock after timeout.
class InactivityService {
  InactivityService({
    required this.timeoutMinutes,
    required this.onInactivityTimeout,
    this.enabled = true,
  });

  /// Timeout duration in minutes.
  int timeoutMinutes;

  /// Callback when inactivity timeout is reached.
  final InactivityCallback onInactivityTimeout;

  /// Whether inactivity tracking is enabled.
  bool enabled;

  Timer? _inactivityTimer;

  /// Record user activity and reset the timer.
  void recordActivity() {
    if (!enabled || timeoutMinutes <= 0) return;
    _resetTimer();
  }

  /// Start tracking inactivity.
  void start() {
    if (!enabled || timeoutMinutes <= 0) return;
    _resetTimer();

    if (kDebugMode) {
      print('InactivityService: Started with ${timeoutMinutes}min timeout');
    }
  }

  /// Stop tracking inactivity.
  void stop() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;

    if (kDebugMode) {
      print('InactivityService: Stopped');
    }
  }

  /// Update timeout duration.
  void updateTimeout(int minutes) {
    timeoutMinutes = minutes;
    if (enabled && minutes > 0) {
      _resetTimer();
    } else {
      stop();
    }
  }

  /// Update enabled state.
  void setEnabled(bool value) {
    enabled = value;
    if (enabled && timeoutMinutes > 0) {
      start();
    } else {
      stop();
    }
  }

  void _resetTimer() {
    _inactivityTimer?.cancel();

    if (!enabled || timeoutMinutes <= 0) return;

    _inactivityTimer = Timer(Duration(minutes: timeoutMinutes), _handleTimeout);
  }

  void _handleTimeout() {
    if (!enabled) return;

    if (kDebugMode) {
      print('InactivityService: Timeout reached, triggering lock');
    }

    onInactivityTimeout();
  }

  /// Dispose of resources.
  void dispose() {
    stop();
  }
}
