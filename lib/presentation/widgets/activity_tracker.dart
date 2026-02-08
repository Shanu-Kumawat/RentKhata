/// Activity tracking wrapper widget for inactivity detection.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/providers/biometric_providers.dart';
import '../../services/inactivity_service.dart';

/// Provider for the inactivity service instance.
final inactivityServiceProvider = Provider<InactivityService?>((ref) {
  // Will be initialized by ActivityTracker widget
  return null;
});

/// Widget that wraps the app to track user activity for inactivity timeout.
class ActivityTracker extends ConsumerStatefulWidget {
  const ActivityTracker({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ActivityTracker> createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends ConsumerState<ActivityTracker>
    with WidgetsBindingObserver {
  InactivityService? _inactivityService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeService();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityService?.dispose();
    super.dispose();
  }

  void _initializeService() {
    // Service will be created after settings are loaded
  }

  void _setupService(int timeoutMinutes, bool enabled, bool lockOnExit) {
    if (_inactivityService == null) {
      _inactivityService = InactivityService(
        timeoutMinutes: timeoutMinutes,
        enabled: enabled && timeoutMinutes > 0,
        onInactivityTimeout: _handleTimeout,
      );
      if (enabled && timeoutMinutes > 0) {
        _inactivityService!.start();
      }
    } else {
      _inactivityService!.updateTimeout(timeoutMinutes);
      _inactivityService!.setEnabled(enabled && timeoutMinutes > 0);
    }
  }

  void _handleTimeout() {
    // Lock the app
    ref.read(appLockStateProvider.notifier).lock();
    // Navigate to lock screen using GoRouter
    if (mounted) {
      context.go('/lock');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final settings = ref.read(biometricSettingsNotifierProvider).valueOrNull;
    final isEnabled = settings?.isEnabled ?? false;
    final lockOnExit = settings?.lockOnExit ?? true;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App going to background
        if (isEnabled && lockOnExit) {
          ref.read(appLockStateProvider.notifier).lock();
        }
        _inactivityService?.stop();
      case AppLifecycleState.resumed:
        // App returning to foreground
        // Navigate to lock screen if locked
        if (isEnabled) {
          final isLocked = ref.read(appLockStateProvider);
          if (isLocked && mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) context.go('/lock');
            });
          }
        }
        // Restart inactivity timer
        if (isEnabled && (settings?.lockAfterMinutes ?? 0) > 0) {
          _inactivityService?.start();
        }
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // No action needed
        break;
    }
  }

  void _recordActivity() {
    _inactivityService?.recordActivity();
  }

  @override
  Widget build(BuildContext context) {
    // Watch settings to react to changes
    final settingsAsync = ref.watch(biometricSettingsNotifierProvider);

    settingsAsync.whenData((settings) {
      final isEnabled = settings?.isEnabled ?? false;
      final lockOnExit = settings?.lockOnExit ?? true;
      final timeoutMinutes = settings?.lockAfterMinutes ?? 0;

      _setupService(timeoutMinutes, isEnabled, lockOnExit);
    });

    // Wrap with Listener to detect all pointer events
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _recordActivity(),
      onPointerMove: (_) => _recordActivity(),
      onPointerUp: (_) => _recordActivity(),
      child: widget.child,
    );
  }
}
