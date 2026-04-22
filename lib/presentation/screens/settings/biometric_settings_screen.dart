/// Biometric settings screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/biometric_providers.dart';
import '../../../services/biometric_service.dart';
import '../../widgets/bouncing_scale_wrapper.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

/// Settings screen for biometric app lock configuration.
class BiometricSettingsScreen extends ConsumerWidget {
  const BiometricSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricSupport = ref.watch(biometricSupportProvider);
    final settingsAsync = ref.watch(biometricSettingsNotifierProvider);

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appLock)),
      body: biometricSupport.when(
        data: (support) => _buildContent(context, ref, support, settingsAsync, l10n),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('${l10n.errorPrefix}$e')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    BiometricSupport support,
    AsyncValue settingsAsync,
    AppLocalizations l10n,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    if (support == BiometricSupport.notAvailable) {
      return _buildNotAvailableContent(context, l10n);
    }

    if (support == BiometricSupport.notEnrolled) {
      return _buildNotEnrolledContent(context, l10n);
    }

    return settingsAsync.when(
      data: (settings) {
        final isEnabled = settings?.isEnabled ?? false;
        final lockOnExit = settings?.lockOnExit ?? true;
        final lockAfterMinutes = settings?.lockAfterMinutes ?? 0;

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            // Header info
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.fingerprint,
                      size: 32,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.biometricLock,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.biometricLockSubtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Enable toggle
            BouncingScaleWrapper(
              child: SwitchListTile(
                title: Text(l10n.enableAppLock),
                subtitle: Text(l10n.requireBiometric),
                value: isEnabled,
                onChanged: (value) {
                  ref
                      .read(biometricSettingsNotifierProvider.notifier)
                      .setEnabled(value);
                },
              ),
            ),

            const Divider(),

            // Additional options (only shown when enabled)
            AnimatedOpacity(
              opacity: isEnabled ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: !isEnabled,
                child: Column(
                  children: [
                    // Lock on exit
                    BouncingScaleWrapper(
                      child: SwitchListTile(
                        title: Text(l10n.lockOnExit),
                        subtitle: Text(
                          l10n.lockOnExitSubtitle,
                        ),
                        value: lockOnExit,
                        onChanged: (value) {
                          ref
                              .read(biometricSettingsNotifierProvider.notifier)
                              .setLockOnExit(value);
                        },
                      ),
                    ),
                    // Lock after inactivity
                    BouncingScaleWrapper(
                      child: ListTile(
                        title: Text(l10n.lockAfterInactivity),
                        subtitle: Text(_getInactivityLabel(lockAfterMinutes, l10n)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showInactivityPicker(
                          context,
                          ref,
                          lockAfterMinutes,
                          l10n,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Info section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.biometricFallbackInfo,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('${l10n.errorPrefix}$e')),
    );
  }

  Widget _buildNotAvailableContent(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.fingerprint,
                size: 64,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.biometricsNotAvailable,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.deviceDoesNotSupportBiometrics,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotEnrolledContent(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.fingerprint,
                size: 64,
                color: colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noBiometricsEnrolled,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.setupFingerprintFirst,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInactivityLabel(int minutes, AppLocalizations l10n) {
    if (minutes <= 0) return l10n.never;
    if (minutes == 1) return l10n.oneMinute;
    return l10n.minutes(minutes);
  }

  void _showInactivityPicker(
    BuildContext context,
    WidgetRef ref,
    int currentValue,
    AppLocalizations l10n,
  ) {
    final options = [
      (0, l10n.never),
      (1, l10n.oneMinute),
      (5, l10n.minutes(5)),
      (15, l10n.minutes(15)),
      (30, l10n.minutes(30)),
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.lockAfterInactivity,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ...options.map(
              (option) => ListTile(
                leading: Icon(
                  option.$1 == currentValue
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: option.$1 == currentValue
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
                title: Text(option.$2),
                onTap: () {
                  ref
                      .read(biometricSettingsNotifierProvider.notifier)
                      .setLockAfterMinutes(option.$1);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
