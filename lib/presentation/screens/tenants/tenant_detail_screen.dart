/// Tenant detail screen with comprehensive profile, occupancy history.
library;

import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/database_provider.dart';
import '../../../data/database/app_database.dart';
import '../../../data/database/tables/family_member_table.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/tenant.dart';
import '../../../domain/entities/occupancy.dart';
import '../../../domain/entities/document.dart';
import 'package:open_file/open_file.dart';
import 'add_tenant_screen.dart';
import 'add_document_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.tenantDetail)),
            body: Center(child: Text(AppLocalizations.of(context)!.tenantNotFound)),
          );
        }
        return _TenantDetailContent(tenant: tenant);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.error(e.toString()))),
        body: Center(child: Text(AppLocalizations.of(context)!.error(e.toString()))),
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
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.deleteTenant),
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
                title: AppLocalizations.of(context)!.personalDetails,
                icon: Icons.person_outline,
                children: [
                  if (tenant.fatherName != null)
                    _InfoRow(
                      icon: Icons.person_outline,
                      label: AppLocalizations.of(context)!.fathersName,
                      value: tenant.fatherName!,
                    ),
                  if (tenant.age != null)
                    _InfoRow(
                      icon: Icons.cake_outlined,
                      label: AppLocalizations.of(context)!.age,
                      value: AppLocalizations.of(context)!.years(tenant.age!),
                    ),
                  if (tenant.gender != null)
                    _InfoRow(
                      icon: Icons.wc_outlined,
                      label: AppLocalizations.of(context)!.gender,
                      value: _formatGender(tenant.gender!),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Contact Information
            _buildInfoSection(
              context,
              title: AppLocalizations.of(context)!.contactInformation,
              icon: Icons.phone_outlined,
              children: [
                if (tenant.phone != null)
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: AppLocalizations.of(context)!.phone,
                    value: tenant.phone!,
                    onTap: () => _launchPhone(tenant.phone!),
                  ),
                if (tenant.secondaryPhone != null)
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: AppLocalizations.of(context)!.secondaryPhone,
                    value: tenant.secondaryPhone!,
                    onTap: () => _launchPhone(tenant.secondaryPhone!),
                  ),
                if (tenant.aadharNumber != null)
                  _InfoRow(
                    icon: Icons.credit_card_outlined,
                    label: AppLocalizations.of(context)!.aadhaar,
                    value: tenant.aadharNumber!,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Permanent Address Section
            if (_hasAddressDetails()) ...[
              _buildInfoSection(
                context,
                title: AppLocalizations.of(context)!.permanentAddress,
                icon: Icons.home_outlined,
                children: [
                  if (tenant.permanentAddressLine != null)
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: AppLocalizations.of(context)!.address,
                      value: tenant.permanentAddressLine!,
                    ),
                  if (tenant.permanentCity != null ||
                      tenant.permanentState != null)
                    _InfoRow(
                      icon: Icons.location_city_outlined,
                      label: AppLocalizations.of(context)!.cityState,
                      value: [
                        tenant.permanentCity,
                        tenant.permanentState,
                      ].whereType<String>().join(', '),
                    ),
                  if (tenant.permanentPincode != null)
                    _InfoRow(
                      icon: Icons.pin_drop_outlined,
                      label: AppLocalizations.of(context)!.pincode,
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
                title: AppLocalizations.of(context)!.workDetails,
                icon: Icons.work_outline,
                children: [
                  if (tenant.companyName != null)
                    _InfoRow(
                      icon: Icons.business_outlined,
                      label: AppLocalizations.of(context)!.company,
                      value: tenant.companyName!,
                    ),
                  if (tenant.officeAddress != null)
                    _InfoRow(
                      icon: Icons.location_city_outlined,
                      label: AppLocalizations.of(context)!.officeAddress,
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
                title: AppLocalizations.of(context)!.introducerReference,
                icon: Icons.handshake_outlined,
                children: [
                  if (tenant.introducerName != null)
                    _InfoRow(
                      icon: Icons.person_outline,
                      label: AppLocalizations.of(context)!.name,
                      value: tenant.introducerName!,
                    ),
                  if (tenant.introducerAddress != null)
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: AppLocalizations.of(context)!.address,
                      value: tenant.introducerAddress!,
                    ),
                  if (tenant.introducerPhone != null)
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: AppLocalizations.of(context)!.phone,
                      value: tenant.introducerPhone!,
                      onTap: () => _launchPhone(tenant.introducerPhone!),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // ID Documents Section (Aadhaar photos)
            if (tenant.aadhaarFrontPhotoPath != null ||
                tenant.aadhaarBackPhotoPath != null) ...[
              _buildInfoSection(
                context,
                title: 'ID Documents',
                icon: Icons.badge_outlined,
                children: [
                  if (tenant.aadharNumber != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.credit_card_outlined,
                            size: 18,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Aadhaar: ${tenant.aadharNumber}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      if (tenant.aadhaarFrontPhotoPath != null)
                        Expanded(
                          child: _AadhaarPhotoTile(
                            label: 'Front',
                            imagePath: tenant.aadhaarFrontPhotoPath!,
                          ),
                        ),
                      if (tenant.aadhaarFrontPhotoPath != null &&
                          tenant.aadhaarBackPhotoPath != null)
                        const SizedBox(width: 12),
                      if (tenant.aadhaarBackPhotoPath != null)
                        Expanded(
                          child: _AadhaarPhotoTile(
                            label: 'Back',
                            imagePath: tenant.aadhaarBackPhotoPath!,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Police verification
            _VerificationCard(tenant: tenant),
            const SizedBox(height: 16),

            // Family Members Section
            occupanciesAsync.when(
              data: (occupancies) {
                final activeOccupancy = occupancies
                    .where((o) => o.isActive)
                    .firstOrNull;
                return _FamilyMembersSection(
                  tenantId: tenant.id,
                  currentOccupancyId: activeOccupancy?.id,
                );
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (_, __) => _FamilyMembersSection(tenantId: tenant.id),
            ),
            const SizedBox(height: 16),

            // Documents Section
            _DocumentsSection(tenantId: tenant.id),
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
    // Allow all widget types - just check if we have any children
    if (children.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
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
            ...children,
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
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
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
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                tenant.name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
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
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
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
      color: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.5),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.home_outlined,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
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
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(value, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

// ============ Aadhaar Photo Tile with Fullscreen View ============

class _AadhaarPhotoTile extends StatelessWidget {
  final String label;
  final String imagePath;

  const _AadhaarPhotoTile({required this.label, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showFullscreenImage(context),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  // Expand indicator
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  void _showFullscreenImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullscreenImageViewer(
          imagePath: imagePath,
          title: 'Aadhaar $label',
        ),
      ),
    );
  }
}

// ============ Fullscreen Image Viewer with Share ============

class _FullscreenImageViewer extends StatelessWidget {
  final String imagePath;
  final String title;

  const _FullscreenImageViewer({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share',
            onPressed: () => _shareImage(context),
          ),
        ],
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Image.file(
            File(imagePath),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.broken_image_outlined,
                  size: 64,
                  color: Colors.white54,
                ),
                const SizedBox(height: 16),
                Text(
                  'Unable to load image',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _shareImage(BuildContext context) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        // Use share_plus to share the image file
        await Share.shareXFiles([
          XFile(imagePath),
        ], text: 'Aadhaar Card - $title');
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Image file not found')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sharing: $e')));
      }
    }
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
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            tenant.isPoliceVerified
                ? Icons.verified_user
                : Icons.verified_user_outlined,
            color: tenant.isPoliceVerified
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Icon(
                Icons.history_outlined,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Occupancy History',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              occupanciesAsync.when(
                data: (list) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${list.length} stay${list.length != 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        occupanciesAsync.when(
          data: (occupancies) {
            if (occupancies.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 48,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No occupancy history yet',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: occupancies
                  .map((occ) => _OccupancyHistoryCard(occupancy: occ))
                  .toList(),
            );
          },
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (e, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(child: Text('Error: $e')),
            ),
          ),
        ),
      ],
    );
  }
}

class _OccupancyHistoryCard extends StatelessWidget {
  final Occupancy occupancy;

  const _OccupancyHistoryCard({required this.occupancy});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM yyyy');
    final start = dateFormat.format(occupancy.moveInDate);
    final end = occupancy.moveOutDate != null
        ? dateFormat.format(occupancy.moveOutDate!)
        : 'Present';

    final isActive = occupancy.isActive;
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          context.push('/occupancies/${occupancy.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isActive ? Icons.home_filled : Icons.history,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      occupancy.propertyName ?? 'Property',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Room ${occupancy.roomNumber ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$start - $end',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Rent & Chevron
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCurrency(occupancy.agreedRent),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    '/month',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============ Family Members Section ============

class _FamilyMembersSection extends ConsumerWidget {
  final int tenantId;
  final int? currentOccupancyId;

  const _FamilyMembersSection({
    required this.tenantId,
    this.currentOccupancyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyMembersAsync = ref.watch(
      familyMembersForTenantProvider(tenantId),
    );

    return Card(
      child: ExpansionTile(
        leading: Icon(
          Icons.family_restroom_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('Family Members'),
        subtitle: familyMembersAsync.when(
          data: (members) => Text(
            currentOccupancyId != null
                ? '${members.length} current member(s)'
                : 'View occupancy history for past members',
          ),
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
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            currentOccupancyId != null
                                ? 'No family members added'
                                : 'No active occupancy - view past occupancies for family history',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...members.map(
                      (member) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          child: Text(
                            member.name[0].toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
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
                        trailing: currentOccupancyId != null
                            ? IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                onPressed: () => _deleteFamilyMember(
                                  context,
                                  ref,
                                  member.id,
                                ),
                              )
                            : null,
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (currentOccupancyId != null)
                    OutlinedButton.icon(
                      onPressed: () => _showAddFamilyMember(context, ref),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Family Member'),
                    )
                  else
                    Text(
                      'Family members can only be added to active occupancies',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
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
    // Only allow adding if we have a current occupancy
    if (currentOccupancyId == null) return;

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
                      initialValue: selectedRelationship,
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
                      initialValue: selectedGender,
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
                            occupancyId: currentOccupancyId!,
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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

// ============ Documents Section ============

class _DocumentsSection extends ConsumerWidget {
  final int tenantId;

  const _DocumentsSection({required this.tenantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(tenantDocumentsProvider(tenantId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Documents',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _showAddDocumentSheet(context, ref),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            documentsAsync.when(
              data: (documents) {
                if (documents.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'No documents attached.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final doc = documents[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: doc.fileType == 'image'
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(doc.filePath),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 20),
                                ),
                              )
                            : const Icon(Icons.description, size: 20),
                      ),
                      title: Text(
                        doc.title,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        DateFormat('dd MMM yyyy').format(doc.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined),
                            onPressed: () => _viewDocument(context, doc),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () => _deleteDocument(context, ref, doc),
                          ),
                        ],
                      ),
                      onTap: () => _viewDocument(context, doc),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDocumentSheet(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddDocumentSheet(tenantId: tenantId),
    );

    if (result == true) {
      ref.invalidate(tenantDocumentsProvider(tenantId));
    }
  }

  void _viewDocument(BuildContext context, Document doc) {
    if (doc.fileType == 'image') {
      OpenFile.open(doc.filePath);
    } else {
      // Fallback for other types
      OpenFile.open(doc.filePath);
    }
  }

  void _deleteDocument(
    BuildContext context,
    WidgetRef ref,
    Document doc,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document?'),
        content: Text('Are you sure you want to delete "${doc.title}"?'),
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
      await ref.read(tenantRepositoryProvider).deleteDocument(doc.id);
      ref.invalidate(tenantDocumentsProvider(tenantId));
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Document deleted')));
      }
    }
  }
}
