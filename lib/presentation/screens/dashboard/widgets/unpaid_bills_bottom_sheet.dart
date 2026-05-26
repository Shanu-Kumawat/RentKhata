import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/bill.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';

class UnpaidBillsBottomSheet extends StatelessWidget {
  final List<Bill> unpaidBills;

  const UnpaidBillsBottomSheet({super.key, required this.unpaidBills});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Collect Payments',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select a bill below to review it and collect its pending payment.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: unpaidBills.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, indent: 20, endIndent: 20),
            itemBuilder: (context, index) {
              final bill = unpaidBills[index];
              return _UnpaidBillTile(bill: bill);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _UnpaidBillTile extends StatelessWidget {
  final Bill bill;

  const _UnpaidBillTile({required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue = bill.isOverdue;
    final statusColor = isOverdue ? theme.colorScheme.error : AppColors.warning;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap: () {
        Navigator.pop(context);
        context.push('/bills/${bill.id}');
      },
      title: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              '${bill.billNumber} • ${formatCurrency(bill.pendingAmount)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      subtitle: Text(
        isOverdue
            ? 'Overdue since ${bill.dueDate?.day ?? ''}/${bill.dueDate?.month ?? ''}'
            : 'Awaiting payment',
        style: TextStyle(
          fontSize: 12,
          color: statusColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
          context.push('/bills/${bill.id}');
        },
        style: OutlinedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          foregroundColor: theme.colorScheme.error,
          side: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Collect',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
