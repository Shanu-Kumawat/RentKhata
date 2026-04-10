import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/billing_status.dart';
import '../../../../domain/entities/bill.dart';
import '../../../../core/theme/app_colors.dart';

class AttentionBottomSheet extends StatelessWidget {
  final List<BillingAttentionItem> attentionItems;

  const AttentionBottomSheet({super.key, required this.attentionItems});

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
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
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
                    color: Colors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.receipt_long_outlined, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Pending Invoices',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select a tenant below to generate their upcoming or overdue bill.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: attentionItems.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20),
            itemBuilder: (context, index) {
              final item = attentionItems[index];
              return _BillingAttentionTile(item: item);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _BillingAttentionTile extends StatelessWidget {
  final BillingAttentionItem item;

  const _BillingAttentionTile({required this.item});

  String _billTypeLabel(BillType type) => switch (type) {
    BillType.rent => 'Rent',
    BillType.electricity => 'Elec',
    BillType.water => 'Water',
    BillType.maintenance => 'Maint',
    BillType.other => 'Other',
  };

  Color _billTypeColor(BuildContext context, BillType type) => switch (type) {
    BillType.rent => Theme.of(context).colorScheme.primary,
    BillType.electricity => Theme.of(context).colorScheme.error,
    BillType.water => Colors.blue,
    BillType.maintenance => Colors.green,
    BillType.other => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final isOverdue = item.status == BillingCycleStatus.overdue;
    final statusColor = isOverdue
        ? Theme.of(context).colorScheme.error
        : AppColors.warning; 
    final statusTextColor = isOverdue
        ? Theme.of(context).colorScheme.error
        : AppColors.warning;
    final billColor = _billTypeColor(context, item.billType);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap: () {
        Navigator.pop(context); // close sheet
        context.push(
          '/rooms/${item.roomId}?createBill=true'
          '&cycleStart=${item.cycleStart.toIso8601String()}'
          '&cycleEnd=${item.cycleEnd.toIso8601String()}'
          '&billType=${item.billType.name}',
        );
      },
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: billColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: billColor.withValues(alpha: 0.3)),
        ),
        child: Text(
          _billTypeLabel(item.billType),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: billColor,
          ),
        ),
      ),
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
              'Room ${item.roomNumber} - ${item.tenantName}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Text(
        item.cycleEndDescription,
        style: TextStyle(
          fontSize: 12,
          color: statusTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
          context.push(
            '/rooms/${item.roomId}?createBill=true'
            '&cycleStart=${item.cycleStart.toIso8601String()}'
            '&cycleEnd=${item.cycleEnd.toIso8601String()}'
            '&billType=${item.billType.name}',
          );
        },
        style: OutlinedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          foregroundColor: Colors.blue,
          side: BorderSide(color: Colors.blue.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Text('Create', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
