import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../application/providers/tenant_providers.dart';
import '../../../../core/theme/app_colors.dart';

class ExpiringAgreementsBottomSheet extends StatelessWidget {
  final List<AgreementExpirationStatus> expiringAgreements;

  const ExpiringAgreementsBottomSheet({super.key, required this.expiringAgreements});

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
                    color: AppColors.warning.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.handshake_outlined, color: AppColors.warning, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Renew Agreements',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select a tenant below to view their profile and update their agreement status.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: expiringAgreements.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20),
            itemBuilder: (context, index) {
              final status = expiringAgreements[index];
              return _ExpiringAgreementTile(status: status);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ExpiringAgreementTile extends StatelessWidget {
  final AgreementExpirationStatus status;

  const _ExpiringAgreementTile({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpired = status.isExpired;
    final statusColor = isExpired ? theme.colorScheme.error : AppColors.warning;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap: () {
        Navigator.pop(context);
        // We can navigate to the tenant profile or room detail
        context.push('/rooms/${status.occupancy.roomId}');
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
              '${status.occupancy.tenantName ?? 'Tenant'}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Text(
        isExpired 
            ? 'Expired ${-status.daysRemaining} days ago' 
            : 'Expiring in ${status.daysRemaining} days',
        style: TextStyle(
          fontSize: 12,
          color: statusColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
          context.push('/rooms/${status.occupancy.roomId}');
        },
        style: OutlinedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          foregroundColor: AppColors.warning,
          side: BorderSide(color: AppColors.warning.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text('Renew', style: TextStyle(fontWeight: FontWeight.bold, color: statusColor)),
      ),
    );
  }
}
