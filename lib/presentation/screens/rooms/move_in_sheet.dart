/// Move-in flow screen for assigning tenant to room with family member selection.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  DateTime _moveInDate = DateTime.now();
  Tenant? _selectedTenant;
  bool _isLoading = false;
  bool _createNewTenant = false;

  // New tenant fields
  final _newNameController = TextEditingController();
  final _newPhoneController = TextEditingController();
  final _newFatherNameController = TextEditingController();
  final _newAgeController = TextEditingController();
  final _newAadharController = TextEditingController();
  String? _selectedGender;

  // Family member selection for returning tenants
  Set<int> _selectedFamilyMemberIds = {};

  @override
  void initState() {
    super.initState();
    _rentController.text = widget.room.baseRent.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _rentController.dispose();
    _depositController.dispose();
    _newNameController.dispose();
    _newPhoneController.dispose();
    _newFatherNameController.dispose();
    _newAgeController.dispose();
    _newAadharController.dispose();
    super.dispose();
  }

  Future<void> _selectMoveInDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _moveInDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
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
    HapticFeedback.mediumImpact();

    try {
      final tenantRepo = ref.read(tenantRepositoryProvider);
      int tenantId;

      if (_createNewTenant) {
        // Create new tenant with expanded fields
        tenantId = await tenantRepo.createTenant(
          name: _newNameController.text.trim(),
          phone: _newPhoneController.text.trim().isEmpty
              ? null
              : _newPhoneController.text.trim(),
          fatherName: _newFatherNameController.text.trim().isEmpty
              ? null
              : _newFatherNameController.text.trim(),
          age: int.tryParse(_newAgeController.text),
          gender: _selectedGender,
          aadharNumber: _newAadharController.text.trim().isEmpty
              ? null
              : _newAadharController.text.trim(),
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
          SnackBar(
            content: Text(
              _selectedFamilyMemberIds.isNotEmpty
                  ? 'Tenant moved in with ${_selectedFamilyMemberIds.length} family members'
                  : 'Tenant moved in successfully',
            ),
          ),
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
                          onTap: () => setState(() {
                            _createNewTenant = false;
                            _selectedFamilyMemberIds.clear();
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ToggleButton(
                          label: 'New Tenant',
                          isSelected: _createNewTenant,
                          onTap: () => setState(() {
                            _createNewTenant = true;
                            _selectedTenant = null;
                            _selectedFamilyMemberIds.clear();
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  if (_createNewTenant) ...[
                    // New tenant fields - expanded
                    _buildNewTenantForm(),
                  ] else ...[
                    // Tenant selection
                    tenantsAsync.when(
                      data: (tenants) {
                        // Filter out tenants who are already occupying a room
                        final availableTenants = tenants
                            .where((t) => !t.isCurrentlyOccupying)
                            .toList();

                        if (availableTenants.isEmpty) {
                          return _buildNoTenantsMessage();
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
                                onTap: () {
                                  setState(() {
                                    _selectedTenant = tenant;
                                    _selectedFamilyMemberIds.clear();
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, s) => Text('Error: $e'),
                    ),

                    // Family member selection for returning tenants
                    if (_selectedTenant != null) ...[
                      const SizedBox(height: 16),
                      _FamilyMemberSelection(
                        tenantId: _selectedTenant!.id,
                        selectedIds: _selectedFamilyMemberIds,
                        onSelectionChanged: (ids) {
                          setState(() => _selectedFamilyMemberIds = ids);
                        },
                      ),
                    ],
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

                  // Move-in date with future date indicator
                  InkWell(
                    onTap: _selectMoveInDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Move-in Date',
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        suffixIcon: _moveInDate.isAfter(DateTime.now())
                            ? Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.info.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Future',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(color: AppColors.info),
                                ),
                              )
                            : null,
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
                  const SizedBox(height: 16),

                  // Info card
                  Card(
                    color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Security deposit will be marked as collected on move-in date',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          : Text(
                              _selectedFamilyMemberIds.isEmpty
                                  ? 'Confirm Move-In'
                                  : 'Move-In with ${_selectedFamilyMemberIds.length} Family Members',
                            ),
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

  Widget _buildNewTenantForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person_add_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'New Tenant Details',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) => validateRequired(v, 'Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newFatherNameController,
              decoration: const InputDecoration(
                labelText: 'Father\'s Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _newAgeController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: (v) => setState(() => _selectedGender = v),
                  ),
                ),
              ],
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
            const SizedBox(height: 16),
            TextFormField(
              controller: _newAadharController,
              decoration: const InputDecoration(
                labelText: 'Aadhaar Number',
                prefixIcon: Icon(Icons.credit_card_outlined),
                hintText: '12-digit number',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.info,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You can add more details like documents and family members after move-in',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.info),
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

  Widget _buildNoTenantsMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No available tenants. Create a new tenant or add tenants who are not currently occupying any room.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

// ============ Family Member Selection Widget ============

class _FamilyMemberSelection extends ConsumerWidget {
  final int tenantId;
  final Set<int> selectedIds;
  final Function(Set<int>) onSelectionChanged;

  const _FamilyMemberSelection({
    required this.tenantId,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyMembersAsync = ref.watch(
      familyMembersForTenantProvider(tenantId),
    );

    return familyMembersAsync.when(
      data: (members) {
        if (members.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.family_restroom_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Family Members',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        if (selectedIds.length == members.length) {
                          onSelectionChanged({});
                        } else {
                          onSelectionChanged(members.map((m) => m.id).toSet());
                        }
                      },
                      child: Text(
                        selectedIds.length == members.length
                            ? 'Deselect All'
                            : 'Select All',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Select family members who will also move in:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                ...members.map(
                  (member) => CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: selectedIds.contains(member.id),
                    onChanged: (checked) {
                      final newSet = Set<int>.from(selectedIds);
                      if (checked ?? false) {
                        newSet.add(member.id);
                      } else {
                        newSet.remove(member.id);
                      }
                      onSelectionChanged(newSet);
                    },
                    title: Text(member.name),
                    subtitle: Text(
                      [
                        member.relationship.name,
                        if (member.age != null) '${member.age} yrs',
                      ].join(' • '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    secondary: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.secondary.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        member.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

// ============ Toggle Button ============

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

// ============ Tenant Radio Tile ============

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
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
              child: Text(
                tenant.name[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Past tenant indicator
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.onSurfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        title: Text(tenant.name),
        subtitle: tenant.phone != null
            ? Text(tenant.phone!)
            : const Text('Past Tenant'),
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
