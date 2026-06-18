/// Dashboard screen - main home screen.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rent_khata/l10n/app_localizations.dart';

import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/billing_cycle_providers.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../application/providers/property_providers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/attention_bottom_sheet.dart';
import 'widgets/unpaid_bills_bottom_sheet.dart';
import 'widgets/expiring_agreements_bottom_sheet.dart';
import 'widgets/premium_animated_orb.dart';
import '../onboarding/widgets/premium_permission_sheet.dart';
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
      appBar: AppBar(title: Text(l10n.appTitle)),
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
              StaggeredFadeIn(
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
            ],
          ),
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
    final isLoading =
        billingAttentionAsync.isLoading ||
        unpaidBillsAsync.isLoading ||
        expiringAgreementsAsync.isLoading;
    if (!isLoading &&
        attentionItems.isEmpty &&
        unpaidBills.isEmpty &&
        expiring.isEmpty) {
      return _EmptyAttentionCard();
    }

    if (isLoading &&
        attentionItems.isEmpty &&
        unpaidBills.isEmpty &&
        expiring.isEmpty) {
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
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.6,
                    maxChildSize: 0.9,
                    minChildSize: 0.4,
                    expand: false,
                    builder: (_, scrollController) => SingleChildScrollView(
                      controller: scrollController,
                      child: AttentionBottomSheet(
                        attentionItems: attentionItems,
                      ),
                    ),
                  ),
                );
              },
            ),

          if (attentionItems.isNotEmpty &&
              (unpaidBills.isNotEmpty || expiring.isNotEmpty))
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.6,
                    maxChildSize: 0.9,
                    minChildSize: 0.4,
                    expand: false,
                    builder: (_, scrollController) => SingleChildScrollView(
                      controller: scrollController,
                      child: ExpiringAgreementsBottomSheet(
                        expiringAgreements: expiring,
                      ),
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
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
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
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideX(
          begin: 0.05,
          end: 0,
          curve: Curves.easeOutCubic,
          duration: 400.ms,
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
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child:
                        Icon(
                              Icons.check_rounded,
                              size: 28,
                              color: Theme.of(context).colorScheme.primary,
                            )
                            .animate(
                              onPlay: (controller) =>
                                  controller.repeat(reverse: true),
                            )
                            .scaleXY(
                              begin: 1.0,
                              end: 1.15,
                              duration: 2.seconds,
                              curve: Curves.easeInOutSine,
                            )
                            .shimmer(
                              delay: 2.seconds,
                              duration: 1.5.seconds,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.5),
                            ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.allCaughtUp,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
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
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        )
        .then()
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: -2,
          end: 2,
          duration: 3.seconds,
          curve: Curves.easeInOutSine,
        )
        .shimmer(
          delay: 2.seconds,
          duration: 2.seconds,
          color: Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: 0.8),
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
          return const _SmartEmptyState();
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
                )
                .animate()
                .fadeIn(delay: (100 + (index * 100)).ms, duration: 400.ms)
                .slideY(
                  begin: 0.1,
                  end: 0,
                  curve: Curves.easeOutCubic,
                  duration: 400.ms,
                );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Text('${AppLocalizations.of(context)!.errorPrefix}$e'),
    );
  }
}

class _SmartEmptyState extends ConsumerWidget {
  const _SmartEmptyState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRoomsAsync = ref.watch(allRoomsStreamProvider());
    final propertiesAsync = ref.watch(propertiesStreamProvider());

    if (allRoomsAsync.isLoading || propertiesAsync.isLoading) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final properties = propertiesAsync.valueOrNull ?? [];
    final rooms = allRoomsAsync.valueOrNull ?? [];

    if (properties.isEmpty) {
      return _buildCard(
        context,
        icon: Icons.domain_add_rounded,
        title: "Let's Get Started",
        subtitle: "Add your first property to begin managing your tenants.",
        actionLabel: "Add Property",
        onAction: () => context.push('/properties/add'),
      );
    }

    if (rooms.isEmpty) {
      return _buildCard(
        context,
        icon: Icons.door_front_door_outlined,
        title: "Property Ready! \u{1F389}",
        subtitle:
            "Your property is set up. Let's add your first room to start tracking rent.",
        actionLabel: "Add a Room",
        onAction: () => context.push('/properties/${properties.first.id}'),
      );
    }

    return _buildCard(
      context,
      icon: Icons.person_add_alt_1_rounded,
      title: "Rooms Available",
      subtitle:
          "You have empty rooms waiting for tenants. Add a tenant to start tracking.",
      actionLabel: "Add Tenant",
      onAction: () async {
        final result = await context.push('/tenants/add');
        if (result == true) {
          if (!context.mounted) return;
          await PremiumPermissionSheet.showBiometrics(context, ref);
        }
      },
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAction,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                PremiumAnimatedOrb(
                  icon: icon,
                  primaryColor: theme.colorScheme.primary,
                  secondaryColor: theme.colorScheme.secondary,
                  size: 130,
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 12),
                Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                        fontSize: 15,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 100.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 32),
                FilledButton.icon(
                      onPressed: onAction,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 20)
                          .animate(onPlay: (controller) => controller.repeat())
                          .moveX(
                            begin: 0,
                            end: 4,
                            duration: 1.seconds,
                            curve: Curves.easeInOut,
                          )
                          .then()
                          .moveX(
                            begin: 4,
                            end: 0,
                            duration: 1.seconds,
                            curve: Curves.easeInOut,
                          ),
                      label: Text(
                        actionLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 16,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, curve: Curves.easeOutCubic);
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
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Leading Icon Badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.meeting_room_rounded,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                // Middle Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.roomNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.tenantName} • ${item.propertyName}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Trailing Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
