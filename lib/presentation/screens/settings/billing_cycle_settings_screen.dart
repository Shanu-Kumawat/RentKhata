import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/database_provider.dart';
import '../../../data/database/app_database.dart';
import '../../../application/providers/billing_cycle_providers.dart';
import 'dart:async';
import 'package:rent_khata/l10n/app_localizations.dart';

enum _SaveStatus { idle, saving, saved, error }

/// Billing cycle settings screen for configuring date-to-date billing
/// Auto-saves changes immediately without a save button
class BillingCycleSettingsScreen extends ConsumerStatefulWidget {
  const BillingCycleSettingsScreen({super.key});

  @override
  ConsumerState<BillingCycleSettingsScreen> createState() =>
      _BillingCycleSettingsScreenState();
}

class _BillingCycleSettingsScreenState
    extends ConsumerState<BillingCycleSettingsScreen> {
  // Local state for optimistic UI
  int? _dueDateOffsetDays;
  int? _dueSoonThresholdDays;
  bool? _rentUsesDateToDate;
  bool? _electricityUsesDateToDate;
  bool? _waterUsesDateToDate;
  bool? _maintenanceUsesDateToDate;
  bool? _otherUsesDateToDate;

  bool _initialized = false;
  Timer? _debounceTimer;
  _SaveStatus _saveStatus = _SaveStatus.idle;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _initialize(BillSettingsEntity settings) {
    if (_initialized) return;
    _dueDateOffsetDays = settings.dueDateOffsetDays;
    _dueSoonThresholdDays = settings.dueSoonThresholdDays;
    _rentUsesDateToDate = settings.rentUsesDateToDate;
    _electricityUsesDateToDate = settings.electricityUsesDateToDate;
    _waterUsesDateToDate = settings.waterUsesDateToDate;
    _maintenanceUsesDateToDate = settings.maintenanceUsesDateToDate;
    _otherUsesDateToDate = settings.otherUsesDateToDate;
    _initialized = true;
  }

  /// Debounced save function
  void _saveChanges() {
    setState(() => _saveStatus = _SaveStatus.saving);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      _commitToDb();
    });
  }

  Future<void> _commitToDb() async {
    if (!mounted) return;
    try {
      final db = ref.read(appDatabaseProvider);

      // Build companion with all current local values
      final companion = BillSettingsCompanion(
        dueDateOffsetDays: Value(_dueDateOffsetDays!),
        dueSoonThresholdDays: Value(_dueSoonThresholdDays!),
        rentUsesDateToDate: Value(_rentUsesDateToDate!),
        electricityUsesDateToDate: Value(_electricityUsesDateToDate!),
        waterUsesDateToDate: Value(_waterUsesDateToDate!),
        maintenanceUsesDateToDate: Value(_maintenanceUsesDateToDate!),
        otherUsesDateToDate: Value(_otherUsesDateToDate!),
        updatedAt: Value(DateTime.now()),
      );

      await (db.update(
        db.billSettings,
      )..where((t) => t.id.equals(1))).write(companion);

      if (mounted) {
        setState(() => _saveStatus = _SaveStatus.saved);

        // Return to idle after delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _saveStatus == _SaveStatus.saved) {
            setState(() => _saveStatus = _SaveStatus.idle);
          }
        });

        // Invalidate providers to refresh all dependent widgets
        ref.invalidate(billSettingsProvider);
        ref.invalidate(billingAttentionConfigProvider);
        ref.invalidate(billingAttentionListProvider);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saveStatus = _SaveStatus.error);
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.errorPrefix}$e')));
      }
    }
  }

  void _updateDueDateOffset(int value) {
    if (value != _dueDateOffsetDays) HapticFeedback.selectionClick();
    setState(() => _dueDateOffsetDays = value);
    _saveChanges();
  }

  void _updateDueSoonThreshold(int value) {
    if (value != _dueSoonThresholdDays) HapticFeedback.selectionClick();
    setState(() => _dueSoonThresholdDays = value);
    _saveChanges();
  }

  void _updateBillType(String type, bool value) {
    HapticFeedback.lightImpact();
    setState(() {
      switch (type) {
        case 'rent':
          _rentUsesDateToDate = value;
          break;
        case 'electricity':
          _electricityUsesDateToDate = value;
          break;
        case 'water':
          _waterUsesDateToDate = value;
          break;
        case 'maintenance':
          _maintenanceUsesDateToDate = value;
          break;
        case 'other':
          _otherUsesDateToDate = value;
          break;
      }
    });
    _saveChanges();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(billSettingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.configureBillingCycles),
        actions: [_buildAppBarStatus(), const SizedBox(width: 16)],
      ),
      body: _initialized
          ? _buildContent(context, l10n)
          : settingsAsync.when(
              skipLoadingOnRefresh: true,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('${l10n.errorPrefix}$e')),
              data: (settings) {
                _initialize(settings);
                return _buildContent(context, l10n);
              },
            ),
    );
  }

  Widget _buildAppBarStatus() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (_saveStatus) {
        _SaveStatus.saving => const SizedBox(
          key: ValueKey('saving'),
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
        _SaveStatus.saved => Icon(
          Icons.check_circle_outline,
          key: const ValueKey('saved'),
          color: Colors.green.shade600,
        ),
        _SaveStatus.error => Icon(
          Icons.error_outline,
          key: const ValueKey('error'),
          color: Theme.of(context).colorScheme.error,
        ),
        _SaveStatus.idle => const SizedBox(key: ValueKey('idle')),
      },
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.changesSavedAutomatically,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Due Date Offset
          Text(
            l10n.dueDate,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.dueDateOffsetSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Slider(
            value: (_dueDateOffsetDays ?? 5).toDouble(),
            min: 1,
            max: 15,
            divisions: 14,
            label: l10n.daysCount(_dueDateOffsetDays ?? 5),
            onChanged: (v) => _updateDueDateOffset(v.round()),
          ),
          Center(
            child: Text(
              l10n.dueDaysAfterCycle(_dueDateOffsetDays ?? 5),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Due Soon Threshold
          Text(
            l10n.dueSoonAlert,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.dueSoonAlertSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Slider(
            value: (_dueSoonThresholdDays ?? 5).toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: l10n.daysCount(_dueSoonThresholdDays ?? 5),
            onChanged: (v) => _updateDueSoonThreshold(v.round()),
          ),
          Center(
            child: Text(
              l10n.alertDaysBeforeCycle(_dueSoonThresholdDays ?? 5),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Date-to-Date Billing Toggles
          Text(
            l10n.dateToDateBillingByBillType,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.dateToDateBillingSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),

          _buildBillTypeToggle(
            label: l10n.rent,
            subtitle: l10n.monthlyRentBills,
            value: _rentUsesDateToDate ?? true,
            onChanged: (v) => _updateBillType('rent', v),
            icon: Icons.home_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          _buildBillTypeToggle(
            label: l10n.electricity,
            subtitle: l10n.electricityMeterBills,
            value: _electricityUsesDateToDate ?? true,
            onChanged: (v) => _updateBillType('electricity', v),
            icon: Icons.bolt_outlined,
            color: Theme.of(context).colorScheme.error,
          ),
          _buildBillTypeToggle(
            label: l10n.water,
            subtitle: l10n.waterBill,
            value: _waterUsesDateToDate ?? false,
            onChanged: (v) => _updateBillType('water', v),
            icon: Icons.water_drop_outlined,
            color: Colors.blue,
          ),
          _buildBillTypeToggle(
            label: l10n.maintenance,
            subtitle: l10n.maintenanceCharges,
            value: _maintenanceUsesDateToDate ?? false,
            onChanged: (v) => _updateBillType('maintenance', v),
            icon: Icons.build_outlined,
            color: Colors.green,
          ),
          _buildBillTypeToggle(
            label: l10n.other,
            subtitle: l10n.otherCharges,
            value: _otherUsesDateToDate ?? false,
            onChanged: (v) => _updateBillType('other', v),
            icon: Icons.receipt_outlined,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBillTypeToggle({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    required Color color,
  }) {
    return SwitchListTile(
      title: Text(label),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
