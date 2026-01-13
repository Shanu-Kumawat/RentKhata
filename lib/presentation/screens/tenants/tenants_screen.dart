/// Tenants list screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/tenant.dart';

/// Screen displaying all tenants.
class TenantsScreen extends ConsumerStatefulWidget {
  const TenantsScreen({super.key});

  @override
  ConsumerState<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends ConsumerState<TenantsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tenantsAsync = _searchQuery.isEmpty
        ? ref.watch(tenantsStreamProvider)
        : ref.watch(searchTenantsProvider(_searchQuery));

    return Scaffold(
      appBar: AppBar(title: const Text('Tenants')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or phone...',
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
                  : _buildTenantList(context, tenants),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline,
                size: 64,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _searchQuery.isEmpty ? 'No tenants yet' : 'No tenants found',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty
                  ? 'Tenants will appear here after you move them into a room'
                  : 'Try a different search term',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenantList(BuildContext context, List<Tenant> tenants) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tenants.length,
      itemBuilder: (context, index) {
        final tenant = tenants[index];
        return _TenantCard(tenant: tenant);
      },
    );
  }
}

class _TenantCard extends StatelessWidget {
  final Tenant tenant;

  const _TenantCard({required this.tenant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/tenants/${tenant.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: tenant.photoPath != null
                    ? AssetImage(tenant.photoPath!)
                    : null,
                child: tenant.photoPath == null
                    ? Text(
                        tenant.name.isNotEmpty
                            ? tenant.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              // Tenant info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_outlined,
                                  size: 12,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Verified',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(color: AppColors.success),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (tenant.phone != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.phone_outlined,
                            size: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tenant.phone!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    // Current occupancy status
                    if (tenant.isCurrentlyOccupying &&
                        tenant.currentRoomNumber != null)
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${tenant.currentPropertyName ?? ''} - Room ${tenant.currentRoomNumber}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.success),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.onSurfaceVariant.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Past Tenant',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
