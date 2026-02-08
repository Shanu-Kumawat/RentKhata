/// Biometric settings screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/biometric_providers.dart';
import '../../../services/biometric_service.dart';
import '../../widgets/bouncing_scale_wrapper.dart';

/// Settings screen for biometric app lock configuration.
class BiometricSettingsScreen extends ConsumerWidget {
  const BiometricSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricSupport = ref.watch(biometricSupportProvider);
    final settingsAsync = ref.watch(biometricSettingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('App Lock')),
      body: biometricSupport.when(
        data: (support) => _buildContent(context, ref, support, settingsAsync),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    BiometricSupport support,
    AsyncValue settingsAsync,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    if (support == BiometricSupport.notAvailable) {
      return _buildNotAvailableContent(context);
    }

    if (support == BiometricSupport.notEnrolled) {
      return _buildNotEnrolledContent(context);
    }

    return settingsAsync.when(
      data: (settings) {
        final isEnabled = settings?.isEnabled ?? false;
        final lockOnExit = settings?.lockOnExit ?? true;

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
                          'Biometric Lock',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Protect your rental data with fingerprint or device PIN',
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
                title: const Text('Enable App Lock'),
                subtitle: const Text('Require biometric to open app'),
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
                        title: const Text('Lock on Exit'),
                        subtitle: const Text(
                          'Lock immediately when app goes to background',
                        ),
                        value: lockOnExit,
                        onChanged: (value) {
                          ref
                              .read(biometricSettingsNotifierProvider.notifier)
                              .setLockOnExit(value);
                        },
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
                        'When locked, you can also use your device PIN, pattern, or password as a fallback.',
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
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildNotAvailableContent(BuildContext context) {
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
              'Biometrics Not Available',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your device does not support biometric authentication.',
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

  Widget _buildNotEnrolledContent(BuildContext context) {
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
              'No Biometrics Enrolled',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Please set up fingerprint or face recognition in your device settings first.',
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
}
