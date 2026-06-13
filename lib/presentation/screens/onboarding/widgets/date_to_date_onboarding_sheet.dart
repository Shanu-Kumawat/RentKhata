import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:drift/drift.dart' as drift;
import 'package:rent_khata/l10n/app_localizations.dart';

import '../../../../application/providers/billing_providers.dart';
import '../../../../application/providers/repository_providers.dart';
import '../../../../data/database/app_database.dart';

class DateToDateOnboardingSheet extends ConsumerStatefulWidget {
  const DateToDateOnboardingSheet({super.key});

  @override
  ConsumerState<DateToDateOnboardingSheet> createState() =>
      _DateToDateOnboardingSheetState();
}

class _DateToDateOnboardingSheetState extends ConsumerState<DateToDateOnboardingSheet> {
  // Default values
  bool _rent = true;
  bool _electricity = true;
  bool _water = false;
  bool _maintenance = false;
  bool _other = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  Future<void> _loadCurrentSettings() async {
    final settings = await ref.read(billSettingsProvider.future);
    if (mounted) {
      setState(() {
        _rent = settings.rentUsesDateToDate;
        _electricity = settings.electricityUsesDateToDate;
        _water = settings.waterUsesDateToDate;
        _maintenance = settings.maintenanceUsesDateToDate;
        _other = settings.otherUsesDateToDate;
      });
    }
  }

  Future<void> _saveAndContinue() async {
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(billingRepositoryProvider);
      await repo.updateBillSettings(
        BillSettingsCompanion(
          rentUsesDateToDate: drift.Value(_rent),
          electricityUsesDateToDate: drift.Value(_electricity),
          waterUsesDateToDate: drift.Value(_water),
          maintenanceUsesDateToDate: drift.Value(_maintenance),
          otherUsesDateToDate: drift.Value(_other),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving preferences: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, bottomInset + 32),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.5,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.event_repeat_rounded,
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
              ).animate().scale(
                delay: 100.ms,
                begin: const Offset(0, 0),
                curve: Curves.easeOutBack,
              ),

              const SizedBox(height: 16),

              Text(
                'Configure Billing Cycles',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideY(begin: 0.2),

              const SizedBox(height: 8),

              Text(
                'Calculate bills based on the tenant\'s exact move-in date (Date-to-Date) rather than calendar months.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms)
              .slideY(begin: 0.2),

              const SizedBox(height: 24),

              // Toggles
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildToggle(
                      title: l10n.rent,
                      value: _rent,
                      onChanged: (v) => setState(() => _rent = v),
                      theme: theme,
                    ),
                    const Divider(height: 1),
                    _buildToggle(
                      title: l10n.electricity,
                      value: _electricity,
                      onChanged: (v) => setState(() => _electricity = v),
                      theme: theme,
                    ),
                    const Divider(height: 1),
                    _buildToggle(
                      title: l10n.water,
                      value: _water,
                      onChanged: (v) => setState(() => _water = v),
                      theme: theme,
                    ),
                    const Divider(height: 1),
                    _buildToggle(
                      title: l10n.maintenance,
                      value: _maintenance,
                      onChanged: (v) => setState(() => _maintenance = v),
                      theme: theme,
                    ),
                    const Divider(height: 1),
                    _buildToggle(
                      title: l10n.other,
                      value: _other,
                      onChanged: (v) => setState(() => _other = v),
                      theme: theme,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

              const SizedBox(height: 32),

              // Actions Layout
              FilledButton(
                onPressed: _isLoading ? null : _saveAndContinue,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Save & Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              )
              .animate()
              .fadeIn(delay: 500.ms)
              .slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggle({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ThemeData theme,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.white,
      activeTrackColor: theme.colorScheme.primary,
      inactiveThumbColor: theme.colorScheme.surface,
      inactiveTrackColor: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
