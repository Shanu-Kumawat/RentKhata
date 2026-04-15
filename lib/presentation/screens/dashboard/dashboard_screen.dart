/// Dashboard screen - main home screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/billing_cycle_providers.dart';
import '../../../application/providers/tenant_providers.dart';
import 'widgets/attention_bottom_sheet.dart';
import 'widgets/unpaid_bills_bottom_sheet.dart';
import 'widgets/expiring_agreements_bottom_sheet.dart';
import '../../../core/theme/app_colors.dart';

import '../../widgets/bouncing_scale_wrapper.dart';
import '../../widgets/staggered_fade_in.dart';


/// Main dashboard screen showing financial overview and actionable items.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _refresh(WidgetRef ref) {
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(unpaidBillsProvider);
    ref.invalidate(filteredFinancialsProvider);
    ref.invalidate(roomStatusListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch necessary providers
    // (Variables removed to silence warnings)

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          // Prominent Reports button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => context.push('/reports'),
              icon: const Icon(Icons.assessment_outlined, size: 20),
              label: Text(l10n.reports),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh(ref);
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Section: Action Center (Priority Zone)
              const StaggeredFadeIn(
                delay: Duration(milliseconds: 0),
                child: Column(
                  children: [
                    _SectionHeader(
                      icon: Icons.notifications_active_outlined,
                      title: l10n.attentionNeeded,
                    ),
                    SizedBox(height: 12),
                    _ActionRequiredSection(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Bottom Section: Live Property Status
              StaggeredFadeIn(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    _SectionHeader(
                      icon: Icons.meeting_room_outlined,
                      title: l10n.livePropertyStatus,
                    ),
                    const SizedBox(height: 12),
                    _LivePropertyStatusList(),
                  ],
                ),
              ),
              const SizedBox(height: 80), // Bottom padding for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          _showQuickActions(context);
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.quickAdd),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.home_work_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(l10n.addProperty),
              onTap: () {
                Navigator.pop(context);
                context.push('/properties/add');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person_add_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              title: Text(l10n.addTenant),
              onTap: () {
                Navigator.pop(context);
                context.push('/tenants/add');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error, // Warning context
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              title: Text(l10n.createBill),
              subtitle: Text(l10n.goToRoomToCreateBills),
              onTap: () {
                Navigator.pop(context);
                context.push('/properties');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}



class _ActionRequiredSection extends ConsumerWidget {
  const _ActionRequiredSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unpaidBillsAsync = ref.watch(unpaidBillsProvider);
    final billingAttentionAsync = ref.watch(billingAttentionListProvider);
    final expiringAgreementsAsync = ref.watch(expiringAgreementsProvider);
    final theme = Theme.of(context);

    final l10n = AppLocalizations.of(context)!;

    // Compute loaded states
    final attentionItems = billingAttentionAsync.valueOrNull ?? [];
    final unpaidBills = unpaidBillsAsync.valueOrNull ?? [];
    final expiring = expiringAgreementsAsync.valueOrNull ?? [];

    // If completely empty and finished loading, show empty state
    final isLoading = billingAttentionAsync.isLoading || unpaidBillsAsync.isLoading || expiringAgreementsAsync.isLoading;
    if (!isLoading && attentionItems.isEmpty && unpaidBills.isEmpty && expiring.isEmpty) {
      return _EmptyAttentionCard();
    }

    if (isLoading && attentionItems.isEmpty && unpaidBills.isEmpty && expiring.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          if (attentionItems.isNotEmpty)
            _ActionTile(
              icon: Icons.receipt_long_outlined,
              iconColor: Colors.blue,
              title: l10n.pendingInvoices,
              subtitle: l10n.tenantsNeedBills(attentionItems.length),
              badgeColor: Colors.blue,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.6,
                    maxChildSize: 0.9,
                    minChildSize: 0.4,
                    expand: false,
                    builder: (_, scrollController) => SingleChildScrollView(
                      controller: scrollController,
                      child: AttentionBottomSheet(attentionItems: attentionItems),
                    ),
                  ),
                );
              },
            ),
          
          if (attentionItems.isNotEmpty && (unpaidBills.isNotEmpty || expiring.isNotEmpty))
            const Divider(height: 1, indent: 64),

          if (unpaidBills.isNotEmpty)
            _ActionTile(
              icon: Icons.account_balance_wallet_outlined,
              iconColor: theme.colorScheme.error,
              title: l10n.collectPayments,
              subtitle: l10n.billsAwaitPayment(unpaidBills.length),
              badgeColor: theme.colorScheme.error,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.6,
                    maxChildSize: 0.9,
                    minChildSize: 0.4,
                    expand: false,
                    builder: (_, scrollController) => SingleChildScrollView(
                      controller: scrollController,
                      child: UnpaidBillsBottomSheet(unpaidBills: unpaidBills),
                    ),
                  ),
                );
              },
            ),

          if (unpaidBills.isNotEmpty && expiring.isNotEmpty)
            const Divider(height: 1, indent: 64),

          if (expiring.isNotEmpty)
            _ActionTile(
              icon: Icons.handshake_outlined,
              iconColor: AppColors.warning,
              title: l10n.renewAgreements,
              subtitle: l10n.agreementsExpiring(expiring.length),
              badgeColor: AppColors.warning,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.6,
                    maxChildSize: 0.9,
                    minChildSize: 0.4,
                    expand: false,
                    builder: (_, scrollController) => SingleChildScrollView(
                      controller: scrollController,
                      child: ExpiringAgreementsBottomSheet(expiringAgreements: expiring),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color badgeColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: badgeColor.withValues(alpha: 0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card shown when no tenants need billing attention.
class _EmptyAttentionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.allCaughtUp,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    AppLocalizations.of(context)!.noBillingCyclesEnding,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _LivePropertyStatusList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusListAsync = ref.watch(roomStatusListProvider);

    return statusListAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.noActiveRooms));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _RoomStatusTile(item: item),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Text('Error: $e'),
    );
  }
}

class _RoomStatusTile extends StatelessWidget {
  final RoomStatusItem item;

  const _RoomStatusTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(context, item.status);

    return BouncingScaleWrapper(
      onTap: () => context.push('/rooms/${item.roomId}'),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Leading Room Badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      item.roomNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Middle Info
                Expanded(
                  child: Text(
                    item.tenantName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Trailing Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.statusLabel,
                        style: TextStyle(
                          color: _getStatusTextColor(context, item.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, RoomStatusType status) {
    switch (status) {
      case RoomStatusType.paid:
        return Theme.of(context).colorScheme.tertiary; // Success equivalent
      case RoomStatusType.dueSoon:
        return Theme.of(context).colorScheme.error; // Warning equivalent
      case RoomStatusType.overdue:
        return Theme.of(context).colorScheme.error;
    }
  }

  Color _getStatusTextColor(BuildContext context, RoomStatusType status) {
    switch (status) {
      case RoomStatusType.paid:
        return Theme.of(context).colorScheme.tertiary;
      case RoomStatusType.dueSoon:
        return Theme.of(context).colorScheme.error;
      case RoomStatusType.overdue:
        return Theme.of(context).colorScheme.error;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
