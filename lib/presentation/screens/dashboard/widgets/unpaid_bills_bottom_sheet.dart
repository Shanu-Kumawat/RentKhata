import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/bill.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

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
                  AppLocalizations.of(context)!.collectPayments,
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
              AppLocalizations.of(context)!.selectBillToCollect,
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

    final l10n = AppLocalizations.of(context)!;
    final tenantName = bill.tenantName ?? l10n.unknownTenant;
    final roomName = bill.roomNumber ?? l10n.unknownRoom;
    final propertyName = bill.propertyName ?? '';

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        context.push('/bills/${bill.id}', extra: bill);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: Text(
                tenantName.isNotEmpty ? tenantName[0].toUpperCase() : '?',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tenantName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    propertyName.isNotEmpty
                        ? '$roomName • $propertyName'
                        : roomName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
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
                          isOverdue
                              ? l10n.overdueSinceDate(
                                  '${bill.dueDate?.day ?? ''}/${bill.dueDate?.month ?? ''}',
                                )
                              : l10n.awaitingPayment,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(bill.pendingAmount),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/bills/${bill.id}', extra: bill);
                  },
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    foregroundColor: statusColor,
                    side: BorderSide(color: statusColor.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    l10n.collectLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
