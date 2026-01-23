import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/database_provider.dart';
import '../../../data/database/app_database.dart';
import '../../../application/providers/billing_cycle_providers.dart';
import 'dart:async';

enum _SaveStatus { idle, saving, saved, error }

/// Billing cycle settings screen for configuring anniversary billing
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
  bool? _rentUsesAnniversary;
  bool? _electricityUsesAnniversary;
  bool? _waterUsesAnniversary;
  bool? _maintenanceUsesAnniversary;
  bool? _otherUsesAnniversary;

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
    _rentUsesAnniversary = settings.rentUsesAnniversary;
    _electricityUsesAnniversary = settings.electricityUsesAnniversary;
    _waterUsesAnniversary = settings.waterUsesAnniversary;
    _maintenanceUsesAnniversary = settings.maintenanceUsesAnniversary;
    _otherUsesAnniversary = settings.otherUsesAnniversary;
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
        rentUsesAnniversary: Value(_rentUsesAnniversary!),
        electricityUsesAnniversary: Value(_electricityUsesAnniversary!),
        waterUsesAnniversary: Value(_waterUsesAnniversary!),
        maintenanceUsesAnniversary: Value(_maintenanceUsesAnniversary!),
        otherUsesAnniversary: Value(_otherUsesAnniversary!),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving: $e')));
      }
    }
  }

  void _updateDueDateOffset(int value) {
    setState(() => _dueDateOffsetDays = value);
    _saveChanges();
  }

  void _updateDueSoonThreshold(int value) {
    setState(() => _dueSoonThresholdDays = value);
    _saveChanges();
  }

  void _updateBillType(String type, bool value) {
    setState(() {
      switch (type) {
        case 'rent':
          _rentUsesAnniversary = value;
          break;
        case 'electricity':
          _electricityUsesAnniversary = value;
          break;
        case 'water':
          _waterUsesAnniversary = value;
          break;
        case 'maintenance':
          _maintenanceUsesAnniversary = value;
          break;
        case 'other':
          _otherUsesAnniversary = value;
          break;
      }
    });
    _saveChanges();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(billSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing Cycle Settings'),
        actions: [_buildAppBarStatus(), const SizedBox(width: 16)],
      ),
      body: _initialized
          ? _buildContent(context)
          : settingsAsync.when(
              skipLoadingOnRefresh: true,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (settings) {
                _initialize(settings);
                return _buildContent(context);
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

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Changes are saved automatically.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Due Date Offset
          Text(
            'Due Date',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Days after billing cycle ends before bill is due.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Slider(
            value: (_dueDateOffsetDays ?? 5).toDouble(),
            min: 1,
            max: 15,
            divisions: 14,
            label: '${_dueDateOffsetDays ?? 5} days',
            onChanged: (v) => _updateDueDateOffset(v.round()),
          ),
          Center(
            child: Text(
              'Due: ${_dueDateOffsetDays ?? 5} days after cycle ends',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Due Soon Threshold
          Text(
            'Due Soon Alert',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Show "due soon" in Attention when cycle ends within this many days.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Slider(
            value: (_dueSoonThresholdDays ?? 5).toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: '${_dueSoonThresholdDays ?? 5} days',
            onChanged: (v) => _updateDueSoonThreshold(v.round()),
          ),
          Center(
            child: Text(
              'Alert: ${_dueSoonThresholdDays ?? 5} days before cycle ends',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Anniversary Billing Toggles
          Text(
            'Anniversary Billing by Bill Type',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Enable to track billing cycles based on tenant move-in date.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),

          _buildBillTypeToggle(
            label: 'Rent',
            subtitle: 'Monthly rent bills',
            value: _rentUsesAnniversary ?? true,
            onChanged: (v) => _updateBillType('rent', v),
            icon: Icons.home_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          _buildBillTypeToggle(
            label: 'Electricity',
            subtitle: 'Electricity meter bills',
            value: _electricityUsesAnniversary ?? true,
            onChanged: (v) => _updateBillType('electricity', v),
            icon: Icons.bolt_outlined,
            color: Theme.of(context).colorScheme.error,
          ),
          _buildBillTypeToggle(
            label: 'Water',
            subtitle: 'Water bills',
            value: _waterUsesAnniversary ?? false,
            onChanged: (v) => _updateBillType('water', v),
            icon: Icons.water_drop_outlined,
            color: Colors.blue,
          ),
          _buildBillTypeToggle(
            label: 'Maintenance',
            subtitle: 'Maintenance charges',
            value: _maintenanceUsesAnniversary ?? false,
            onChanged: (v) => _updateBillType('maintenance', v),
            icon: Icons.build_outlined,
            color: Colors.green,
          ),
          _buildBillTypeToggle(
            label: 'Other',
            subtitle: 'Other charges',
            value: _otherUsesAnniversary ?? false,
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
