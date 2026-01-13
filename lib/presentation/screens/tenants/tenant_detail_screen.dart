/// Tenant detail screen with custom fields and occupancy history.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/tenant.dart';
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
    final customFieldsAsync = ref.watch(customFieldsForTenantProvider(tenant.id));

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
            // Profile card
            _ProfileCard(tenant: tenant),
            const SizedBox(height: 16),

            // Current occupancy
            if (tenant.isCurrentlyOccupying) ...[
              _CurrentOccupancyCard(tenant: tenant),
              const SizedBox(height: 16),
            ],

            // Contact info
            _InfoSection(
              title: 'Contact Information',
              children: [
                if (tenant.phone != null)
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: tenant.phone!,
                    onTap: () => _launchPhone(tenant.phone!),
                  ),
                if (tenant.aadharNumber != null)
                  _InfoRow(
                    icon: Icons.credit_card_outlined,
                    label: 'Aadhar',
                    value: tenant.aadharNumber!,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Police verification
            _VerificationCard(tenant: tenant),
            const SizedBox(height: 16),

            // Custom fields
            _CustomFieldsSection(
              customFieldsAsync: customFieldsAsync,
              tenantId: tenant.id,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTenant(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTenantScreen(tenant: tenant),
      ),
    );
  }

  void _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
              Navigator.pop(ctx); // Close dialog
              await ref.read(tenantRepositoryProvider).deleteTenant(tenant.id);
              if (context.mounted) {
                context.pop(); // Go back using GoRouter
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tenant deleted')),
                );
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
                  const SizedBox(height: 4),
                  Row(
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
                      const SizedBox(width: 8),
                      Text(
                        tenant.isCurrentlyOccupying
                            ? 'Currently Occupying'
                            : 'Not Assigned',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: tenant.isCurrentlyOccupying
                                  ? AppColors.success
                                  : AppColors.onSurfaceVariant,
                            ),
                      ),
                    ],
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

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
    if (_fieldNameController.text.isEmpty || _fieldValueController.text.isEmpty) {
      return;
    }

    await ref.read(tenantRepositoryProvider).addCustomField(
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
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _isAddingField = !_isAddingField),
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
                          .map((f) => _CustomFieldTile(
                                field: f,
                                onDelete: () async {
                                  await ref
                                      .read(tenantRepositoryProvider)
                                      .deleteCustomField(f.id);
                                  ref.invalidate(
                                      customFieldsForTenantProvider(widget.tenantId));
                                },
                              ))
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.fieldName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                Text(
                  field.fieldValue,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: onDelete,
            color: AppColors.error,
          ),
        ],
      ),
    );
  }
}
