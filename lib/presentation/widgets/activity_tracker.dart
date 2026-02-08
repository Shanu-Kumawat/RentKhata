/// Activity tracking wrapper widget for inactivity detection.
library;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/biometric_providers.dart';
import '../../services/inactivity_service.dart';
import '../router/app_router.dart';

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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize after first frame to ensure providers are ready
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeFromSettings();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityService?.dispose();
    super.dispose();
  }

  void _initializeFromSettings() {
    final settingsAsync = ref.read(biometricSettingsNotifierProvider);
    settingsAsync.whenData((settings) {
      if (settings != null) {
        _setupService(settings.lockAfterMinutes, settings.isEnabled);
        _isInitialized = true;
      }
    });
  }

  void _setupService(int timeoutMinutes, bool enabled) {
    final shouldBeEnabled = enabled && timeoutMinutes > 0;

    if (_inactivityService == null) {
      _inactivityService = InactivityService(
        timeoutMinutes: timeoutMinutes,
        enabled: shouldBeEnabled,
        onInactivityTimeout: _handleTimeout,
      );
      if (shouldBeEnabled) {
        debugPrint(
          'ActivityTracker: Starting timer with $timeoutMinutes min timeout',
        );
        _inactivityService!.start();
      }
    } else {
      _inactivityService!.updateTimeout(timeoutMinutes);
      _inactivityService!.setEnabled(shouldBeEnabled);
    }
  }

  void _handleTimeout() {
    debugPrint('ActivityTracker: Timeout triggered, locking app');
    // Lock the app
    ref.read(appLockStateProvider.notifier).lock();

    // Navigate to lock screen using router provider
    final router = ref.read(routerProvider);
    router.go('/lock');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final settings = ref.read(biometricSettingsNotifierProvider).valueOrNull;
    final isEnabled = settings?.isEnabled ?? false;
    final lockOnExit = settings?.lockOnExit ?? true;
    final timeoutMinutes = settings?.lockAfterMinutes ?? 0;

    debugPrint('ActivityTracker: Lifecycle state changed to $state');

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App going to background
        if (isEnabled && lockOnExit) {
          debugPrint('ActivityTracker: Locking on exit');
          ref.read(appLockStateProvider.notifier).lock();
        }
        _inactivityService?.stop();
      case AppLifecycleState.resumed:
        // App returning to foreground
        // Check if should show lock screen
        if (isEnabled) {
          final isLocked = ref.read(appLockStateProvider);
          if (isLocked) {
            debugPrint(
              'ActivityTracker: App resumed while locked, navigating to lock screen',
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final router = ref.read(routerProvider);
              router.go('/lock');
            });
          }
        }
        // Restart inactivity timer
        if (isEnabled && timeoutMinutes > 0) {
          debugPrint('ActivityTracker: Restarting inactivity timer');
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
      if (settings != null && _isInitialized) {
        _setupService(settings.lockAfterMinutes, settings.isEnabled);
      } else if (settings != null && !_isInitialized) {
        _setupService(settings.lockAfterMinutes, settings.isEnabled);
        _isInitialized = true;
      }
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
