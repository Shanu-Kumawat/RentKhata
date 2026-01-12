/// Electricity rates management screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';

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
    final rate = double.tryParse(_rateController.text);
    if (rate == null || rate <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid rate')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref.read(billingRepositoryProvider).addElectricityRate(rate, DateTime.now());
      _rateController.clear();
      setState(() => _isAddingRate = false);
      ref.invalidate(currentElectricityRateProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rate updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRateAsync = ref.watch(currentElectricityRateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Electricity Rates'),
      ),
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
                      color: AppColors.warning.withOpacity(0.1),
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
                    'Current Rate',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 4),
                  currentRateAsync.when(
                    data: (rate) => Text(
                      '${formatCurrency(rate)}/unit',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, s) => Text('Error: $e'),
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
                        'Update Rate',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (!_isAddingRate)
                        TextButton.icon(
                          onPressed: () =>
                              setState(() => _isAddingRate = true),
                          icon: const Icon(Icons.add),
                          label: const Text('Set New Rate'),
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
                            decoration: const InputDecoration(
                              labelText: 'Rate per unit (₹)',
                              prefixIcon: Icon(Icons.currency_rupee),
                            ),
                            keyboardType: TextInputType.numberWithOptions(
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
                              : const Text('Save'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        _rateController.clear();
                        setState(() => _isAddingRate = false);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'When you create a new electricity bill, the rate at that time is stored with the bill for accurate historical records.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.info,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
