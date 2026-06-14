// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_scheduler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scheduleAllNotificationsHash() =>
    r'25d92032a3c46d4ff34ee408f7027dacd3295cb0';

/// Provider that schedules all notifications on app startup.
///
/// This should be watched in the app's root widget to ensure
/// notifications are always scheduled when the app starts.
///
/// Copied from [scheduleAllNotifications].
@ProviderFor(scheduleAllNotifications)
final scheduleAllNotificationsProvider =
    AutoDisposeFutureProvider<void>.internal(
      scheduleAllNotifications,
      name: r'scheduleAllNotificationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$scheduleAllNotificationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScheduleAllNotificationsRef = AutoDisposeFutureProviderRef<void>;
String _$notificationStartupSchedulerHash() =>
    r'90a57e9f5b67cc34f6fd5db68f0959cc4e9ba1c2';

/// Provider that ensures notifications are scheduled on app startup.
///
/// This is a simple wrapper that triggers the scheduling once
/// and doesn't retry on failure.
///
/// Copied from [NotificationStartupScheduler].
@ProviderFor(NotificationStartupScheduler)
final notificationStartupSchedulerProvider =
    AutoDisposeAsyncNotifierProvider<
      NotificationStartupScheduler,
      bool
    >.internal(
      NotificationStartupScheduler.new,
      name: r'notificationStartupSchedulerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationStartupSchedulerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationStartupScheduler = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
