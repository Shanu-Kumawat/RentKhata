/// Tenants list screen with payment status badges.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/animated_tenant_graphic.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rent_khata/l10n/app_localizations.dart';
import '../../../application/providers/tenant_providers.dart';

import '../../../domain/entities/tenant.dart';

/// Screen displaying all tenants with payment status.
class TenantsScreen extends ConsumerStatefulWidget {
  const TenantsScreen({super.key});

  @override
  ConsumerState<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends ConsumerState<TenantsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showArchived = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tenantsAsync = _searchQuery.isEmpty
        ? ref.watch(tenantsStreamProvider(includeArchived: _showArchived))
        : ref.watch(searchTenantsProvider(_searchQuery, includeArchived: _showArchived));

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tenants),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'toggle_archived') {
                setState(() {
                  _showArchived = !_showArchived;
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle_archived',
                child: Row(
                  children: [
                    Icon(_showArchived ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    const SizedBox(width: 8),
                    Text(_showArchived ? l10n.hideArchived : l10n.showArchived),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchByNameOrPhone,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          // Tenant list
          Expanded(
            child: tenantsAsync.when(
              data: (tenants) => tenants.isEmpty
                  ? _buildEmptyState(context)
                  : _buildTenantList(context, tenants, ref),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text(l10n.error(e.toString()))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedTenantGraphic(),
            const SizedBox(height: 24),
            Text(
                  _searchQuery.isEmpty
                      ? AppLocalizations.of(context)!.noTenantsYet
                      : AppLocalizations.of(context)!.noTenantsFound,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                )
                .animate()
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: 8),
            Text(
                  _searchQuery.isEmpty
                      ? AppLocalizations.of(
                          context,
                        )!.tenantsAppearHereAfterMoveIn
                      : AppLocalizations.of(context)!.tryDifferentSearchTerm,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 300.ms)
                .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }

  Widget _buildTenantList(
    BuildContext context,
    List<Tenant> tenants,
    WidgetRef ref,
  ) {
    // Sort: current tenants first, then past tenants
    final sortedTenants = [...tenants]
      ..sort((a, b) {
        if (a.isCurrentlyOccupying && !b.isCurrentlyOccupying) return -1;
        if (!a.isCurrentlyOccupying && b.isCurrentlyOccupying) return 1;
        return a.name.compareTo(b.name);
      });

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: sortedTenants.length,
      itemBuilder: (context, index) {
        final tenant = sortedTenants[index];
        return _TenantCard(tenant: tenant)
            .animate()
            .fadeIn(delay: (index * 50).ms, duration: 300.ms)
            .slideY(
              begin: 0.1,
              end: 0,
              duration: 300.ms,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }
}

class _TenantCard extends ConsumerWidget {
  final Tenant tenant;

  const _TenantCard({required this.tenant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get occupancy history for past tenants
    final occupanciesAsync = ref.watch(occupanciesForTenantProvider(tenant.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/tenants/${tenant.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar with status indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: tenant.isCurrentlyOccupying
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Text(
                      tenant.name.isNotEmpty
                          ? tenant.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: tenant.isCurrentlyOccupying
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  // Status badge on avatar
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: tenant.isCurrentlyOccupying
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Tenant info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and verified badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tenant.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (tenant.isPoliceVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.verified,
                              size: 14,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Current/Past Badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: tenant.isCurrentlyOccupying
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tenant.isCurrentlyOccupying ? '🟢' : '⚫',
                                style: const TextStyle(fontSize: 8),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                tenant.isCurrentlyOccupying
                                    ? AppLocalizations.of(context)!.current
                                    : AppLocalizations.of(context)!.past,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: tenant.isCurrentlyOccupying
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryContainer
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Location info
                    if (tenant.isCurrentlyOccupying &&
                        tenant.currentRoomNumber != null)
                      Row(
                        children: [
                          Icon(
                            Icons.home_outlined,
                            size: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${tenant.currentPropertyName ?? ''} - Room ${tenant.currentRoomNumber}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else
                      // Past tenant - show last stay info
                      occupanciesAsync.when(
                        data: (occupancies) {
                          if (occupancies.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          // Get last occupancy
                          final lastOccupancy = occupancies.reduce(
                            (a, b) =>
                                a.moveInDate.isAfter(b.moveInDate) ? a : b,
                          );
                          final dateFormat = DateFormat('MMM yyyy');
                          return Row(
                            children: [
                              Icon(
                                Icons.history_outlined,
                                size: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${lastOccupancy.propertyName ?? AppLocalizations.of(context)!.property} - Room ${lastOccupancy.roomNumber ?? AppLocalizations.of(context)!.na} • ${dateFormat.format(lastOccupancy.moveOutDate ?? lastOccupancy.moveInDate)}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),

                    // Phone
                    if (tenant.phone != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tenant.phone!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
