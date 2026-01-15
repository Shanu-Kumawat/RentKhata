/// Tenant detail screen with comprehensive profile, occupancy history.
library;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/database_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/tenant.dart';
import '../../../domain/entities/occupancy.dart';
import '../../../data/database/app_database.dart';
import '../../../data/database/tables/family_member_table.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_tenant_screen.dart';

/// Tenant detail screen showing profile, custom fields, and history.
class TenantDetailScreen extends ConsumerWidget {
  final int tenantId;

  const TenantDetailScreen({super.key, required this.tenantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantAsync = ref.watch(tenantProvider(tenantId));

    return tenantAsync.when(
      data: (tenant) {
        if (tenant == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Tenant')),
            body: const Center(child: Text('Tenant not found')),
          );
        }
        return _TenantDetailContent(tenant: tenant);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _TenantDetailContent extends ConsumerWidget {
  final Tenant tenant;

  const _TenantDetailContent({required this.tenant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customFieldsAsync = ref.watch(
      customFieldsForTenantProvider(tenant.id),
    );
    final occupanciesAsync = ref.watch(occupanciesForTenantProvider(tenant.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(tenant.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditTenant(context),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete(context, ref);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('Delete Tenant'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile card with status badge
            _ProfileCard(tenant: tenant),
            const SizedBox(height: 16),

            // Current occupancy (if active)
            if (tenant.isCurrentlyOccupying) ...[
              _CurrentOccupancyCard(tenant: tenant),
              const SizedBox(height: 16),
            ],

            // Personal Details Section
            if (_hasPersonalDetails()) ...[
              _buildInfoSection(
                context,
                title: 'Personal Details',
                icon: Icons.person_outline,
                children: [
                  if (tenant.fatherName != null)
                    _InfoRow(
                      icon: Icons.person_outline,
                      label: 'Father\'s Name',
                      value: tenant.fatherName!,
                    ),
                  if (tenant.age != null)
                    _InfoRow(
                      icon: Icons.cake_outlined,
                      label: 'Age',
                      value: '${tenant.age} years',
                    ),
                  if (tenant.gender != null)
                    _InfoRow(
                      icon: Icons.wc_outlined,
                      label: 'Gender',
                      value: _formatGender(tenant.gender!),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Contact Information
            _buildInfoSection(
              context,
              title: 'Contact Information',
              icon: Icons.phone_outlined,
              children: [
                if (tenant.phone != null)
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: tenant.phone!,
                    onTap: () => _launchPhone(tenant.phone!),
                  ),
                if (tenant.secondaryPhone != null)
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Secondary Phone',
                    value: tenant.secondaryPhone!,
                    onTap: () => _launchPhone(tenant.secondaryPhone!),
                  ),
                if (tenant.aadharNumber != null)
                  _InfoRow(
                    icon: Icons.credit_card_outlined,
                    label: 'Aadhaar',
                    value: tenant.aadharNumber!,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Permanent Address Section
            if (_hasAddressDetails()) ...[
              _buildInfoSection(
                context,
                title: 'Permanent Address',
                icon: Icons.home_outlined,
                children: [
                  if (tenant.permanentAddressLine != null)
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Address',
                      value: tenant.permanentAddressLine!,
                    ),
                  if (tenant.permanentCity != null ||
                      tenant.permanentState != null)
                    _InfoRow(
                      icon: Icons.location_city_outlined,
                      label: 'City, State',
                      value: [
                        tenant.permanentCity,
                        tenant.permanentState,
                      ].whereType<String>().join(', '),
                    ),
                  if (tenant.permanentPincode != null)
                    _InfoRow(
                      icon: Icons.pin_drop_outlined,
                      label: 'Pincode',
                      value: tenant.permanentPincode!,
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Work Details Section
            if (_hasWorkDetails()) ...[
              _buildInfoSection(
                context,
                title: 'Work Details',
                icon: Icons.work_outline,
                children: [
                  if (tenant.companyName != null)
                    _InfoRow(
                      icon: Icons.business_outlined,
                      label: 'Company',
                      value: tenant.companyName!,
                    ),
                  if (tenant.officeAddress != null)
                    _InfoRow(
                      icon: Icons.location_city_outlined,
                      label: 'Office Address',
                      value: tenant.officeAddress!,
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Introducer Section
            if (_hasIntroducerDetails()) ...[
              _buildInfoSection(
                context,
                title: 'Introducer / Reference',
                icon: Icons.handshake_outlined,
                children: [
                  if (tenant.introducerName != null)
                    _InfoRow(
                      icon: Icons.person_outline,
                      label: 'Name',
                      value: tenant.introducerName!,
                    ),
                  if (tenant.introducerAddress != null)
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Address',
                      value: tenant.introducerAddress!,
                    ),
                  if (tenant.introducerPhone != null)
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: tenant.introducerPhone!,
                      onTap: () => _launchPhone(tenant.introducerPhone!),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Police verification
            _VerificationCard(tenant: tenant),
            const SizedBox(height: 16),

            // Family Members Section
            _FamilyMembersSection(tenantId: tenant.id),
            const SizedBox(height: 16),

            // Occupancy History Section
            _OccupancyHistorySection(
              occupanciesAsync: occupanciesAsync,
              tenant: tenant,
            ),
            const SizedBox(height: 16),

            // Custom fields
            _CustomFieldsSection(
              customFieldsAsync: customFieldsAsync,
              tenantId: tenant.id,
            ),
          ],
        ),
      ),
      // Move In Again FAB for past tenants
      floatingActionButton: !tenant.isCurrentlyOccupying
          ? FloatingActionButton.extended(
              onPressed: () => _showMoveInAgainSheet(context),
              icon: const Icon(Icons.home_outlined),
              label: const Text('Move In Again'),
            )
          : null,
    );
  }

  bool _hasPersonalDetails() =>
      tenant.fatherName != null || tenant.age != null || tenant.gender != null;

  bool _hasAddressDetails() =>
      tenant.permanentAddressLine != null ||
      tenant.permanentCity != null ||
      tenant.permanentState != null ||
      tenant.permanentPincode != null;

  bool _hasWorkDetails() =>
      tenant.companyName != null || tenant.officeAddress != null;

  bool _hasIntroducerDetails() =>
      tenant.introducerName != null ||
      tenant.introducerAddress != null ||
      tenant.introducerPhone != null;

  String _formatGender(String gender) {
    return gender[0].toUpperCase() + gender.substring(1);
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final nonNullChildren = children.where((c) => c is _InfoRow).toList();
    if (nonNullChildren.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...nonNullChildren,
          ],
        ),
      ),
    );
  }

  void _showEditTenant(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTenantScreen(tenant: tenant)),
    );
  }

  void _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showMoveInAgainSheet(BuildContext context) {
    // Navigate to room selection for move-in
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Select a room to move this tenant in')),
    );
    context.push('/rooms');
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Tenant?'),
        content: Text(
          'Are you sure you want to delete ${tenant.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(tenantRepositoryProvider).deleteTenant(tenant.id);
              if (context.mounted) {
                context.pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Tenant deleted')));
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ============ Profile Card ============

class _ProfileCard extends StatelessWidget {
  final Tenant tenant;

  const _ProfileCard({required this.tenant});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                tenant.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tenant.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tenant.isCurrentlyOccupying
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.onSurfaceVariant.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: tenant.isCurrentlyOccupying
                                ? AppColors.success
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tenant.isCurrentlyOccupying
                              ? 'Current Tenant'
                              : 'Past Tenant',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: tenant.isCurrentlyOccupying
                                    ? AppColors.success
                                    : AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
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

// ============ Current Occupancy Card ============

class _CurrentOccupancyCard extends StatelessWidget {
  final Tenant tenant;

  const _CurrentOccupancyCard({required this.tenant});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.success.withValues(alpha: 0.05),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.home_outlined, color: AppColors.success),
        ),
        title: Text(
          '${tenant.currentPropertyName ?? 'Property'} - Room ${tenant.currentRoomNumber}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text('Current Location'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (tenant.currentRoomId != null) {
            context.push('/rooms/${tenant.currentRoomId}');
          }
        },
      ),
    );
  }
}

// ============ Info Row ============

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(value, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

// ============ Verification Card ============

class _VerificationCard extends StatelessWidget {
  final Tenant tenant;

  const _VerificationCard({required this.tenant});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: tenant.isPoliceVerified
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            tenant.isPoliceVerified
                ? Icons.verified_user
                : Icons.verified_user_outlined,
            color: tenant.isPoliceVerified
                ? AppColors.success
                : AppColors.onSurfaceVariant,
          ),
        ),
        title: Text(
          tenant.isPoliceVerified ? 'Police Verified' : 'Not Verified',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          tenant.isPoliceVerified
              ? 'Police verification completed'
              : 'Police verification pending',
        ),
      ),
    );
  }
}

// ============ Occupancy History Section ============

class _OccupancyHistorySection extends StatelessWidget {
  final AsyncValue<List<Occupancy>> occupanciesAsync;
  final Tenant tenant;

  const _OccupancyHistorySection({
    required this.occupanciesAsync,
    required this.tenant,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.history_outlined, color: AppColors.primary),
        title: const Text('Occupancy History'),
        subtitle: occupanciesAsync.when(
          data: (list) => Text('${list.length} stay(s)'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        children: [
          occupanciesAsync.when(
            data: (occupancies) {
              if (occupancies.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 48,
                        color: AppColors.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No occupancy history',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: occupancies
                    .map((occ) => _OccupancyHistoryTile(occupancy: occ))
                    .toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Error: $e'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OccupancyHistoryTile extends StatelessWidget {
  final Occupancy occupancy;

  const _OccupancyHistoryTile({required this.occupancy});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final duration = occupancy.moveOutDate != null
        ? occupancy.moveOutDate!.difference(occupancy.moveInDate).inDays
        : DateTime.now().difference(occupancy.moveInDate).inDays;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: occupancy.isActive
              ? AppColors.success.withValues(alpha: 0.1)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.home_outlined,
          color: occupancy.isActive
              ? AppColors.success
              : AppColors.onSurfaceVariant,
        ),
      ),
      title: Text(
        '${occupancy.propertyName ?? 'Property'} - Room ${occupancy.roomNumber ?? 'N/A'}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${dateFormat.format(occupancy.moveInDate)} - ${occupancy.moveOutDate != null ? dateFormat.format(occupancy.moveOutDate!) : 'Present'}',
          ),
          Row(
            children: [
              Text(
                '$duration days',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '• Rent: ${formatCurrency(occupancy.agreedRent)}/mo',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: occupancy.isActive
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Active',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('/rooms/${occupancy.roomId}');
      },
    );
  }
}

// ============ Family Members Section ============

class _FamilyMembersSection extends ConsumerWidget {
  final int tenantId;

  const _FamilyMembersSection({required this.tenantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyMembersAsync = ref.watch(
      familyMembersForTenantProvider(tenantId),
    );

    return Card(
      child: ExpansionTile(
        leading: const Icon(
          Icons.family_restroom_outlined,
          color: AppColors.primary,
        ),
        title: const Text('Family Members'),
        subtitle: familyMembersAsync.when(
          data: (members) => Text('${members.length} member(s)'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: familyMembersAsync.when(
              data: (members) => Column(
                children: [
                  if (members.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 48,
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No family members added',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    )
                  else
                    ...members.map(
                      (member) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            member.name[0].toUpperCase(),
                            style: const TextStyle(color: AppColors.primary),
                          ),
                        ),
                        title: Text(member.name),
                        subtitle: Text(
                          [
                            member.relationship.name,
                            if (member.age != null) '${member.age} yrs',
                            if (member.gender != null) member.gender,
                          ].join(' • '),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                          onPressed: () =>
                              _deleteFamilyMember(context, ref, member.id),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _showAddFamilyMember(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Family Member'),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteFamilyMember(
    BuildContext context,
    WidgetRef ref,
    int memberId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Family Member?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(appDatabaseProvider);
      await db.tenantDao.deleteFamilyMember(memberId);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Family member deleted')));
      }
    }
  }

  void _showAddFamilyMember(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final ageController = TextEditingController();
    String? selectedRelationship;
    String? selectedGender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Family Member',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Relationship *',
                      ),
                      value: selectedRelationship,
                      items: const [
                        DropdownMenuItem(
                          value: 'spouse',
                          child: Text('Spouse'),
                        ),
                        DropdownMenuItem(value: 'child', child: Text('Child')),
                        DropdownMenuItem(
                          value: 'parent',
                          child: Text('Parent'),
                        ),
                        DropdownMenuItem(
                          value: 'sibling',
                          child: Text('Sibling'),
                        ),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (value) =>
                          setState(() => selectedRelationship = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Gender'),
                      value: selectedGender,
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Male')),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (value) =>
                          setState(() => selectedGender = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone (Optional)',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty ||
                            selectedRelationship == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Name and relationship are required',
                              ),
                            ),
                          );
                          return;
                        }

                        final db = ref.read(appDatabaseProvider);
                        await db.tenantDao.insertFamilyMember(
                          FamilyMembersCompanion.insert(
                            tenantId: tenantId,
                            name: nameController.text,
                            relationship: _stringToRelationship(
                              selectedRelationship!,
                            ),
                            phone: Value(
                              phoneController.text.isEmpty
                                  ? null
                                  : phoneController.text,
                            ),
                            age: Value(int.tryParse(ageController.text)),
                            gender: Value(selectedGender),
                          ),
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Family member added!'),
                            ),
                          );
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  FamilyRelationship _stringToRelationship(String value) {
    switch (value) {
      case 'spouse':
        return FamilyRelationship.spouse;
      case 'child':
        return FamilyRelationship.child;
      case 'parent':
        return FamilyRelationship.parent;
      case 'sibling':
        return FamilyRelationship.sibling;
      default:
        return FamilyRelationship.other;
    }
  }
}

// ============ Custom Fields Section ============

class _CustomFieldsSection extends ConsumerStatefulWidget {
  final AsyncValue<List<CustomField>> customFieldsAsync;
  final int tenantId;

  const _CustomFieldsSection({
    required this.customFieldsAsync,
    required this.tenantId,
  });

  @override
  ConsumerState<_CustomFieldsSection> createState() =>
      _CustomFieldsSectionState();
}

class _CustomFieldsSectionState extends ConsumerState<_CustomFieldsSection> {
  final _fieldNameController = TextEditingController();
  final _fieldValueController = TextEditingController();
  bool _isAddingField = false;

  @override
  void dispose() {
    _fieldNameController.dispose();
    _fieldValueController.dispose();
    super.dispose();
  }

  Future<void> _addField() async {
    if (_fieldNameController.text.isEmpty ||
        _fieldValueController.text.isEmpty) {
      return;
    }

    await ref
        .read(tenantRepositoryProvider)
        .addCustomField(
          tenantId: widget.tenantId,
          fieldName: _fieldNameController.text.trim(),
          fieldValue: _fieldValueController.text.trim(),
        );

    _fieldNameController.clear();
    _fieldValueController.clear();
    setState(() => _isAddingField = false);
    ref.invalidate(customFieldsForTenantProvider(widget.tenantId));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Custom Fields',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () =>
                      setState(() => _isAddingField = !_isAddingField),
                  icon: Icon(_isAddingField ? Icons.close : Icons.add),
                  label: Text(_isAddingField ? 'Cancel' : 'Add Field'),
                ),
              ],
            ),
            if (_isAddingField) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _fieldNameController,
                      decoration: const InputDecoration(
                        labelText: 'Field Name',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _fieldValueController,
                      decoration: const InputDecoration(
                        labelText: 'Value',
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: _addField,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            widget.customFieldsAsync.when(
              data: (fields) => fields.isEmpty
                  ? Text(
                      'No custom fields',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    )
                  : Column(
                      children: fields
                          .map(
                            (f) => _CustomFieldTile(
                              field: f,
                              onDelete: () async {
                                await ref
                                    .read(tenantRepositoryProvider)
                                    .deleteCustomField(f.id);
                                ref.invalidate(
                                  customFieldsForTenantProvider(
                                    widget.tenantId,
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomFieldTile extends StatelessWidget {
  final CustomField field;
  final VoidCallback onDelete;

  const _CustomFieldTile({required this.field, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(field.fieldName),
      subtitle: Text(field.fieldValue),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, size: 20),
        onPressed: onDelete,
      ),
    );
  }
}
