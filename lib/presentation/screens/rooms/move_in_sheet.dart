/// Move-in flow screen for assigning tenant to room.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/tenant.dart';
import '../../../domain/entities/room.dart';

/// Bottom sheet for moving a tenant into a room.
class MoveInSheet extends ConsumerStatefulWidget {
  final int roomId;
  final Room room;

  const MoveInSheet({super.key, required this.roomId, required this.room});

  @override
  ConsumerState<MoveInSheet> createState() => _MoveInSheetState();
}

class _MoveInSheetState extends ConsumerState<MoveInSheet> {
  final _formKey = GlobalKey<FormState>();
  final _rentController = TextEditingController();
  final _depositController = TextEditingController();
  final _searchController = TextEditingController();

  DateTime _moveInDate = DateTime.now();
  Tenant? _selectedTenant;
  bool _isLoading = false;
  bool _createNewTenant = false;

  // New tenant fields
  final _newNameController = TextEditingController();
  final _newPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rentController.text = widget.room.baseRent.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _rentController.dispose();
    _depositController.dispose();
    _searchController.dispose();
    _newNameController.dispose();
    _newPhoneController.dispose();
    super.dispose();
  }

  Future<void> _selectMoveInDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _moveInDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _moveInDate = date);
    }
  }

  Future<void> _saveOccupancy() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_createNewTenant && _selectedTenant == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a tenant')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final tenantRepo = ref.read(tenantRepositoryProvider);
      int tenantId;

      if (_createNewTenant) {
        // Create new tenant first
        tenantId = await tenantRepo.createTenant(
          name: _newNameController.text.trim(),
          phone: _newPhoneController.text.trim().isEmpty
              ? null
              : _newPhoneController.text.trim(),
        );
      } else {
        tenantId = _selectedTenant!.id;
      }

      // Create occupancy
      await tenantRepo.createOccupancy(
        roomId: widget.roomId,
        tenantId: tenantId,
        moveInDate: _moveInDate,
        agreedRent:
            double.tryParse(_rentController.text) ?? widget.room.baseRent,
        securityDeposit: double.tryParse(_depositController.text) ?? 0,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tenant moved in successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tenantsAsync = ref.watch(tenantsProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ListView(
                controller: scrollController,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Move In Tenant',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Room ${widget.room.roomNumber}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Toggle: Select existing or create new
                  Row(
                    children: [
                      Expanded(
                        child: _ToggleButton(
                          label: 'Existing Tenant',
                          isSelected: !_createNewTenant,
                          onTap: () => setState(() => _createNewTenant = false),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ToggleButton(
                          label: 'New Tenant',
                          isSelected: _createNewTenant,
                          onTap: () => setState(() => _createNewTenant = true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  if (_createNewTenant) ...[
                    // New tenant fields
                    TextFormField(
                      controller: _newNameController,
                      decoration: const InputDecoration(
                        labelText: 'Tenant Name *',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) => validateRequired(v, 'Name'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _newPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ] else ...[
                    // Tenant selection
                    tenantsAsync.when(
                      data: (tenants) {
                        // Filter out tenants who are already occupying a room
                        final availableTenants = tenants
                            .where((t) => !t.isCurrentlyOccupying)
                            .toList();

                        if (availableTenants.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'No available tenants. Create a new tenant or add tenants who are not currently occupying any room.',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Tenant',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            ...availableTenants.map(
                              (tenant) => _TenantRadioTile(
                                tenant: tenant,
                                isSelected: _selectedTenant?.id == tenant.id,
                                onTap: () =>
                                    setState(() => _selectedTenant = tenant),
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, s) => Text('Error: $e'),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Move-in details
                  Text(
                    'Move-in Details',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),

                  // Move-in date
                  InkWell(
                    onTap: _selectMoveInDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Move-in Date',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      child: Text(
                        '${_moveInDate.day}/${_moveInDate.month}/${_moveInDate.year}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Agreed rent
                  TextFormField(
                    controller: _rentController,
                    decoration: InputDecoration(
                      labelText: 'Agreed Monthly Rent (₹)',
                      prefixIcon: const Icon(Icons.currency_rupee),
                      helperText:
                          'Base rent: ${formatCurrency(widget.room.baseRent)}',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => validatePositiveNumber(v, 'Rent'),
                  ),
                  const SizedBox(height: 16),

                  // Security deposit
                  TextFormField(
                    controller: _depositController,
                    decoration: const InputDecoration(
                      labelText: 'Security Deposit (₹)',
                      prefixIcon: Icon(Icons.shield_outlined),
                      hintText: '0',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveOccupancy,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Confirm Move-In'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _TenantRadioTile extends StatelessWidget {
  final Tenant tenant;
  final bool isSelected;
  final VoidCallback onTap;

  const _TenantRadioTile({
    required this.tenant,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
          child: Text(
            tenant.name[0].toUpperCase(),
            style: const TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(tenant.name),
        subtitle: tenant.phone != null ? Text(tenant.phone!) : null,
        trailing: Icon(
          isSelected
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
          color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
