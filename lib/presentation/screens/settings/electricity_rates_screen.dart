/// Electricity rates management screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/database_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/database/app_database.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

/// Provider for electricity rate history.
final electricityRateHistoryProvider =
    FutureProvider<List<ElectricityRateEntity>>((ref) async {
      final dao = ref.read(billingDaoProvider);
      return dao.getAllElectricityRates();
    });

/// Screen to manage electricity rates.
class ElectricityRatesScreen extends ConsumerStatefulWidget {
  const ElectricityRatesScreen({super.key});

  @override
  ConsumerState<ElectricityRatesScreen> createState() =>
      _ElectricityRatesScreenState();
}

class _ElectricityRatesScreenState
    extends ConsumerState<ElectricityRatesScreen> {
  final _rateController = TextEditingController();
  bool _isAddingRate = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _addNewRate() async {
    final l10n = AppLocalizations.of(context)!;
    final rate = double.tryParse(_rateController.text);
    if (rate == null || rate <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.enterValidRate)));
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref
          .read(billingRepositoryProvider)
          .addElectricityRate(rate, DateTime.now());
      _rateController.clear();
      setState(() => _isAddingRate = false);
      ref.invalidate(currentElectricityRateProvider);
      ref.invalidate(electricityRateHistoryProvider);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.rateUpdated)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.errorPrefix}$e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentRateAsync = ref.watch(currentElectricityRateProvider);
    final historyAsync = ref.watch(electricityRateHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.electricityRates)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current rate card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bolt,
                      color: AppColors.warning,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.currentRate,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  currentRateAsync.when(
                    data: (rate) => Text(
                      '${formatCurrency(rate)}/${l10n.unit}',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, s) => Text('${l10n.errorPrefix}$e'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Add new rate section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.updateRate,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!_isAddingRate)
                        TextButton.icon(
                          onPressed: () => setState(() => _isAddingRate = true),
                          icon: const Icon(Icons.add),
                          label: Text(l10n.setNewRate),
                        ),
                    ],
                  ),
                  if (_isAddingRate) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _rateController,
                            decoration: InputDecoration(
                              labelText: l10n.ratePerUnitLabel,
                              prefixIcon: const Icon(Icons.currency_rupee),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          onPressed: _isSaving ? null : _addNewRate,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(l10n.save),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        _rateController.clear();
                        setState(() => _isAddingRate = false);
                      },
                      child: Text(l10n.cancel),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Rate History Section
          Text(
            l10n.rateHistory,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          historyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('${l10n.errorPrefix}$e'),
            data: (rates) {
              if (rates.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      l10n.noRateHistory,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }

              return Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rates.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final rate = rates[index];
                    final isCurrentRate = index == 0;
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isCurrentRate
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.bolt,
                          color: isCurrentRate
                              ? AppColors.success
                              : AppColors.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        '${formatCurrency(rate.ratePerUnit)}/${l10n.unit}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: isCurrentRate
                                  ? FontWeight.bold
                                  : null,
                              color: isCurrentRate ? AppColors.success : null,
                            ),
                      ),
                      subtitle: Text(
                        l10n.effectiveFrom(_formatDate(rate.effectiveFrom)),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      trailing: isCurrentRate
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.currentLabel.toUpperCase(),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            )
                          : null,
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.electricityRateInfoText,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.info),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
