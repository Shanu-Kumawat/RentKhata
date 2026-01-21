/// Move-in flow with full tenant form, family member selection, and add new family.
library;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/tenant_providers.dart';
import '../../../application/providers/property_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../application/providers/database_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/tenant.dart';
import '../../../domain/entities/room.dart';
import '../../../data/database/app_database.dart';
import '../../../data/database/tables/family_member_table.dart';
import '../../widgets/image_picker_widget.dart';

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
  DateTime? _billingStartDate; // null means use smart default
  bool _useSeparateBillingDate = false; // User chose to customize
  Tenant? _selectedTenant;
  bool _isLoading = false;
  bool _createNewTenant = false;

  // New tenant fields - FULL FORM matching edit screen
  final _newNameController = TextEditingController();
  final _newFatherNameController = TextEditingController();
  final _newAgeController = TextEditingController();
  final _newPhoneController = TextEditingController();
  final _newSecondaryPhoneController = TextEditingController();
  final _newAadharController = TextEditingController();
  String? _selectedGender;

  // Permanent Address
  final _addressLineController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  // Work Details
  final _companyNameController = TextEditingController();
  final _officeAddressController = TextEditingController();

  // Introducer
  final _introducerNameController = TextEditingController();
  final _introducerAddressController = TextEditingController();
  final _introducerPhoneController = TextEditingController();

  // ID Documents - Aadhaar photos
  String? _aadhaarFrontPath;
  String? _aadhaarBackPath;

  // Family member selection for returning tenants
  Set<int> _selectedFamilyMemberIds = {};

  // New family members to add during move-in
  List<_NewFamilyMember> _newFamilyMembers = [];

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
    _newFatherNameController.dispose();
    _newAgeController.dispose();
    _newPhoneController.dispose();
    _newSecondaryPhoneController.dispose();
    _newAadharController.dispose();
    _addressLineController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _companyNameController.dispose();
    _officeAddressController.dispose();
    _introducerNameController.dispose();
    _introducerAddressController.dispose();
    _introducerPhoneController.dispose();
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
      setState(() {
        _moveInDate = date;
        // Auto-update billing start based on smart default
        _billingStartDate = _calculateSmartBillingStart(date);
      });
    }
  }

  /// Smart default: if move-in > 2 months ago, start billing this month
  DateTime _calculateSmartBillingStart(DateTime moveIn) {
    final now = DateTime.now();
    final twoMonthsAgo = DateTime(now.year, now.month - 2, now.day);

    if (moveIn.isBefore(twoMonthsAgo)) {
      // Old tenant - start billing from current month
      return DateTime(now.year, now.month, moveIn.day.clamp(1, 28));
    } else {
      // Recent move-in - use move-in date
      return moveIn;
    }
  }

  Future<void> _selectBillingStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          _billingStartDate ?? _calculateSmartBillingStart(_moveInDate),
      firstDate: _moveInDate,
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) {
      setState(() {
        _billingStartDate = date;
        _useSeparateBillingDate = true;
      });
    }
  }

  // Check if form is partially filled
  bool get _isPartiallyFilled {
    return _newNameController.text.isNotEmpty &&
        (_newFatherNameController.text.isEmpty ||
            _newPhoneController.text.isEmpty ||
            _newAadharController.text.isEmpty ||
            _addressLineController.text.isEmpty ||
            _cityController.text.isEmpty);
  }

  // Check if all essential fields are filled
  bool get _isFullyFilled {
    return _newNameController.text.isNotEmpty &&
        _newFatherNameController.text.isNotEmpty &&
        _newPhoneController.text.isNotEmpty &&
        _newAadharController.text.isNotEmpty &&
        _addressLineController.text.isNotEmpty &&
        _cityController.text.isNotEmpty;
  }

  Future<void> _saveOccupancy() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_createNewTenant && _selectedTenant == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a tenant')));
      return;
    }

    // Check partial fill for new tenant
    if (_createNewTenant && _isPartiallyFilled && !_isFullyFilled) {
      final proceed = await _showPartialFillDialog();
      if (proceed != true) return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    try {
      final tenantRepo = ref.read(tenantRepositoryProvider);
      final db = ref.read(appDatabaseProvider);
      int tenantId;

      if (_createNewTenant) {
        // Create new tenant with ALL fields
        tenantId = await tenantRepo.createTenant(
          name: _newNameController.text.trim(),
          phone: _emptyToNull(_newPhoneController.text),
          fatherName: _emptyToNull(_newFatherNameController.text),
          age: int.tryParse(_newAgeController.text),
          gender: _selectedGender,
          aadharNumber: _emptyToNull(_newAadharController.text),
          secondaryPhone: _emptyToNull(_newSecondaryPhoneController.text),
          permanentAddressLine: _emptyToNull(_addressLineController.text),
          permanentCity: _emptyToNull(_cityController.text),
          permanentState: _emptyToNull(_stateController.text),
          permanentPincode: _emptyToNull(_pincodeController.text),
          companyName: _emptyToNull(_companyNameController.text),
          officeAddress: _emptyToNull(_officeAddressController.text),
          introducerName: _emptyToNull(_introducerNameController.text),
          introducerAddress: _emptyToNull(_introducerAddressController.text),
          introducerPhone: _emptyToNull(_introducerPhoneController.text),
          aadhaarFrontPhotoPath: _aadhaarFrontPath,
          aadhaarBackPhotoPath: _aadhaarBackPath,
        );
      } else {
        tenantId = _selectedTenant!.id;
      }

      // Create occupancy first - family members now link to occupancy, not tenant
      final effectiveBillingStart =
          _billingStartDate ?? _calculateSmartBillingStart(_moveInDate);
      final occupancyId = await tenantRepo.createOccupancy(
        roomId: widget.roomId,
        tenantId: tenantId,
        moveInDate: _moveInDate,
        agreedRent:
            double.tryParse(_rentController.text) ?? widget.room.baseRent,
        securityDeposit: double.tryParse(_depositController.text) ?? 0,
        billingStartDate: effectiveBillingStart,
      );

      // Add family members to this occupancy
      for (final member in _newFamilyMembers) {
        await db.tenantDao.insertFamilyMember(
          FamilyMembersCompanion.insert(
            occupancyId: occupancyId,
            name: member.name,
            relationship: member.relationship,
            phone: Value(member.phone.isEmpty ? null : member.phone),
            age: Value(member.age),
            gender: Value(member.gender),
          ),
        );
      }

      final totalFamily =
          _selectedFamilyMemberIds.length + _newFamilyMembers.length;

      if (mounted) {
        // Invalidate providers to refresh state across all screens
        ref.invalidate(tenantsProvider);
        ref.invalidate(tenantsStreamProvider);
        ref.invalidate(tenantProvider(tenantId));
        ref.invalidate(roomProvider(widget.roomId));
        ref.invalidate(allRoomsProvider);
        ref.invalidate(propertiesStreamProvider);
        ref.invalidate(roomsForPropertyStreamProvider(widget.room.propertyId));
        ref.invalidate(dashboardSummaryProvider);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              totalFamily > 0
                  ? 'Tenant moved in with $totalFamily family member(s)'
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

  String? _emptyToNull(String text) => text.trim().isEmpty ? null : text.trim();

  Future<bool?> _showPartialFillDialog() {
    final missingFields = <String>[];
    if (_newFatherNameController.text.isEmpty)
      missingFields.add('Father\'s Name');
    if (_newPhoneController.text.isEmpty) missingFields.add('Phone Number');
    if (_newAadharController.text.isEmpty) missingFields.add('Aadhaar Number');
    if (_addressLineController.text.isEmpty)
      missingFields.add('Permanent Address');
    if (_cityController.text.isEmpty) missingFields.add('City');
    if (_aadhaarFrontPath == null) missingFields.add('Aadhaar Front Photo');
    if (_aadhaarBackPath == null) missingFields.add('Aadhaar Back Photo');

    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with warning icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warning,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Incomplete Profile',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${missingFields.length} fields are not filled',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              // Missing fields list
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: missingFields
                      .map(
                        (field) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  field,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Info message
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Complete these later from the Edit Tenant page',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: AppColors.info),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Go Back'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.warning,
                      ),
                      child: const Text('Save Anyway'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddFamilyMemberDialog() {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final phoneController = TextEditingController();
    String? relationship;
    String? gender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
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
                  ctx,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
                      value: relationship,
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
                      onChanged: (v) => setLocalState(() => relationship = v),
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
                      value: gender,
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Male')),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (v) => setLocalState(() => gender = v),
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
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            relationship == null) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                              content: Text('Name and relationship required'),
                            ),
                          );
                          return;
                        }
                        Navigator.pop(ctx);
                        setState(() {
                          _newFamilyMembers.add(
                            _NewFamilyMember(
                              name: nameController.text.trim(),
                              relationship: _stringToRelationship(
                                relationship!,
                              ),
                              age: int.tryParse(ageController.text),
                              gender: gender,
                              phone: phoneController.text.trim(),
                            ),
                          );
                        });
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

  @override
  Widget build(BuildContext context) {
    final tenantsAsync = ref.watch(tenantsProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.5,
        maxChildSize: 0.98,
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
                  _buildHeader(),
                  const SizedBox(height: 24),

                  // Toggle: Select existing or create new
                  _buildToggle(),
                  const SizedBox(height: 24),

                  if (_createNewTenant) ...[
                    _buildFullNewTenantForm(),
                  ] else ...[
                    _buildExistingTenantSelection(tenantsAsync),
                    if (_selectedTenant != null) ...[
                      const SizedBox(height: 16),
                      _FamilyMemberSelection(
                        tenantId: _selectedTenant!.id,
                        selectedIds: _selectedFamilyMemberIds,
                        onSelectionChanged: (ids) =>
                            setState(() => _selectedFamilyMemberIds = ids),
                        newFamilyMembers: _newFamilyMembers,
                        onAddNew: _showAddFamilyMemberDialog,
                        onRemoveNew: (idx) =>
                            setState(() => _newFamilyMembers.removeAt(idx)),
                      ),
                    ],
                  ],
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Move-in details
                  _buildMoveInDetails(),
                  const SizedBox(height: 32),

                  // Save button
                  _buildSaveButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Move In Tenant',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Room ${widget.room.roomNumber}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildToggle() {
    return Row(
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
    );
  }

  Widget _buildFullNewTenantForm() {
    return Column(
      children: [
        // Essential Info Section
        _buildSection('Essential Information', Icons.person_outline, [
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
            controller: _newSecondaryPhoneController,
            decoration: const InputDecoration(
              labelText: 'Secondary Phone',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
          ),
        ]),
        const SizedBox(height: 16),

        // Permanent Address Section
        _buildSection('Permanent Address', Icons.home_outlined, [
          TextFormField(
            controller: _addressLineController,
            decoration: const InputDecoration(
              labelText: 'Address Line',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _pincodeController,
            decoration: const InputDecoration(
              labelText: 'Pincode',
              prefixIcon: Icon(Icons.pin_drop_outlined),
            ),
            keyboardType: TextInputType.number,
          ),
        ]),
        const SizedBox(height: 16),

        // ID Documents Section
        _buildSection('ID Documents', Icons.badge_outlined, [
          TextFormField(
            controller: _newAadharController,
            decoration: const InputDecoration(
              labelText: 'Aadhaar Number',
              hintText: '12-digit number',
              prefixIcon: Icon(Icons.credit_card_outlined),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 20),
          Text(
            'Aadhaar Card Photos',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ImagePickerWidget(
                    initialImagePath: _aadhaarFrontPath,
                    placeholderIcon: Icons.credit_card,
                    size: 100,
                    onImageSelected: (p) =>
                        setState(() => _aadhaarFrontPath = p),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Front',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ImagePickerWidget(
                    initialImagePath: _aadhaarBackPath,
                    placeholderIcon: Icons.credit_card,
                    size: 100,
                    onImageSelected: (p) =>
                        setState(() => _aadhaarBackPath = p),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Back',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]),
        const SizedBox(height: 16),

        // Work Details Section
        _buildSection('Work Details', Icons.work_outline, [
          TextFormField(
            controller: _companyNameController,
            decoration: const InputDecoration(
              labelText: 'Company Name',
              prefixIcon: Icon(Icons.business_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _officeAddressController,
            decoration: const InputDecoration(
              labelText: 'Office Address',
              prefixIcon: Icon(Icons.location_city_outlined),
            ),
            maxLines: 2,
          ),
        ]),
        const SizedBox(height: 16),

        // Introducer Section
        _buildSection('Introducer / Reference', Icons.handshake_outlined, [
          TextFormField(
            controller: _introducerNameController,
            decoration: const InputDecoration(
              labelText: 'Introducer Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _introducerAddressController,
            decoration: const InputDecoration(
              labelText: 'Introducer Address',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _introducerPhoneController,
            decoration: const InputDecoration(
              labelText: 'Introducer Phone',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
          ),
        ]),
        const SizedBox(height: 16),

        // Family Members
        _buildFamilyMembersSectionForNew(),
      ],
    );
  }

  Widget _buildFamilyMembersSectionForNew() {
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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _showAddFamilyMemberDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            if (_newFamilyMembers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No family members added yet',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              )
            else
              ..._newFamilyMembers.asMap().entries.map((e) {
                final idx = e.key;
                final member = e.value;
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                    child: Text(
                      member.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  title: Text(member.name),
                  subtitle: Text(
                    '${member.relationship.name}${member.age != null ? ' • ${member.age} yrs' : ''}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: AppColors.error,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _newFamilyMembers.removeAt(idx)),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
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
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildExistingTenantSelection(AsyncValue<List<Tenant>> tenantsAsync) {
    return tenantsAsync.when(
      data: (tenants) {
        final availableTenants = tenants
            .where((t) => !t.isCurrentlyOccupying)
            .toList();
        if (availableTenants.isEmpty) return _buildNoTenantsMessage();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Tenant',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...availableTenants.map(
              (t) => _TenantRadioTile(
                tenant: t,
                isSelected: _selectedTenant?.id == t.id,
                onTap: () => setState(() {
                  _selectedTenant = t;
                  _selectedFamilyMemberIds.clear();
                  _newFamilyMembers.clear();
                }),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Text('Error: $e'),
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
              'No available tenants. Create a new tenant.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoveInDetails() {
    final effectiveBillingStart =
        _billingStartDate ?? _calculateSmartBillingStart(_moveInDate);
    final isOldMoveIn = _moveInDate.isBefore(
      DateTime.now().subtract(const Duration(days: 60)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Move-in Details', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 16),
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
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: AppColors.info),
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

        // Billing Start Date (shown with smart default info)
        InkWell(
          onTap: _selectBillingStartDate,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Start Billing From',
              prefixIcon: const Icon(Icons.receipt_long_outlined),
              helperText: 'Bills before this date will not be tracked',
              helperMaxLines: 2,
              suffixIcon: isOldMoveIn && !_useSeparateBillingDate
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
                        'Auto',
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: AppColors.info),
                      ),
                    )
                  : null,
            ),
            child: Text(
              '${effectiveBillingStart.day}/${effectiveBillingStart.month}/${effectiveBillingStart.year}',
            ),
          ),
        ),
        if (isOldMoveIn && !_useSeparateBillingDate)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 18,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Older move-in detected. Billing starts from this month.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.info),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _rentController,
          decoration: InputDecoration(
            labelText: 'Agreed Rent (₹)',
            prefixIcon: const Icon(Icons.currency_rupee),
            helperText: 'Base: ${formatCurrency(widget.room.baseRent)}',
          ),
          keyboardType: TextInputType.number,
          validator: (v) => validatePositiveNumber(v, 'Rent'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _depositController,
          decoration: const InputDecoration(
            labelText: 'Security Deposit (₹)',
            prefixIcon: Icon(Icons.shield_outlined),
            hintText: '0',
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    final totalFamily =
        _selectedFamilyMemberIds.length + _newFamilyMembers.length;
    return SizedBox(
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
                totalFamily == 0
                    ? 'Confirm Move-In'
                    : 'Move-In with $totalFamily Family Member${totalFamily > 1 ? 's' : ''}',
              ),
      ),
    );
  }
}

// ============ Helper Classes ============

class _NewFamilyMember {
  final String name;
  final FamilyRelationship relationship;
  final int? age;
  final String? gender;
  final String phone;

  _NewFamilyMember({
    required this.name,
    required this.relationship,
    this.age,
    this.gender,
    required this.phone,
  });
}

// ============ Family Member Selection Widget ============

class _FamilyMemberSelection extends ConsumerWidget {
  final int tenantId;
  final Set<int> selectedIds;
  final Function(Set<int>) onSelectionChanged;
  final List<_NewFamilyMember> newFamilyMembers;
  final VoidCallback onAddNew;
  final Function(int) onRemoveNew;

  const _FamilyMemberSelection({
    required this.tenantId,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.newFamilyMembers,
    required this.onAddNew,
    required this.onRemoveNew,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyMembersAsync = ref.watch(
      familyMembersForTenantProvider(tenantId),
    );

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
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onAddNew,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add New'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            familyMembersAsync.when(
              data: (members) {
                if (members.isEmpty && newFamilyMembers.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No family members. Tap "Add New" to add.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (members.isNotEmpty) ...[
                      Text(
                        'Existing members:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...members.map(
                        (m) => CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          value: selectedIds.contains(m.id),
                          onChanged: (checked) {
                            final newSet = Set<int>.from(selectedIds);
                            if (checked ?? false) {
                              newSet.add(m.id);
                            } else {
                              newSet.remove(m.id);
                            }
                            onSelectionChanged(newSet);
                          },
                          title: Text(m.name),
                          subtitle: Text(
                            '${m.relationship.name}${m.age != null ? ' • ${m.age} yrs' : ''}',
                          ),
                          secondary: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.secondary.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              m.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.secondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (newFamilyMembers.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'New members to add:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...newFamilyMembers.asMap().entries.map((e) {
                        final idx = e.key;
                        final m = e.value;
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.success.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              m.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.success,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          title: Text(m.name),
                          subtitle: Text(
                            '${m.relationship.name}${m.age != null ? ' • ${m.age} yrs' : ''}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: AppColors.error,
                              size: 20,
                            ),
                            onPressed: () => onRemoveNew(idx),
                          ),
                        );
                      }),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
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
