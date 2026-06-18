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
import 'package:rent_khata/l10n/app_localizations.dart';
import 'dart:io';
import '../../../services/image_service.dart';
import '../../widgets/file_preview_dialog.dart';
import '../tenants/add_document_sheet.dart';

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
  DateTime? _agreementEndDate; // Indian 11-month default typically
  bool _useSeparateBillingDate = false; // User chose to customize
  Tenant? _selectedTenant;
  bool _isLoading = false;
  bool _createNewTenant = true;

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
  final List<_NewFamilyMember> _newFamilyMembers = [];

  // Documents
  final List<Map<String, String>> _documents = []; // {path, title}

  @override
  void initState() {
    super.initState();
    _rentController.text = widget.room.baseRent.toStringAsFixed(0);
  }
  // ... (omitted methods)

  Future<void> _pickDocument() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddDocumentSheet(),
    );

    if (result != null) {
      setState(() {
        _documents.add({
          'path': result['path'] as String,
          'title': result['title'] as String,
          'type': result['type'] as String,
        });
      });
    }
  }

  Future<void> _saveDocuments(int tenantId) async {
    final repo = ref.read(tenantRepositoryProvider);
    final imageService = ImageService();
    
    for (final doc in _documents) {
      final isImage = doc['type'] == 'image';
      final persistentFileName = await imageService.saveFileToAppDirectory(
        File(doc['path']!), 
        isImage: isImage,
      );
      
      if (persistentFileName != null) {
        await repo.addDocument(
          tenantId: tenantId,
          title: doc['title']!,
          filePath: persistentFileName,
          fileType: doc['type']!,
        );
      }
    }
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

  Future<void> _selectAgreementEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _agreementEndDate ?? _moveInDate,
      firstDate: _moveInDate,
      lastDate: DateTime(2050),
    );
    if (date != null) {
      setState(() {
        _agreementEndDate = date;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectTenant),
        ),
      );
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
        agreementEndDate: _agreementEndDate,
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

      // Save documents
      if (_documents.isNotEmpty) {
        await _saveDocuments(tenantId);
      }

      final totalFamily =
          _selectedFamilyMemberIds.length + _newFamilyMembers.length;

      if (mounted) {
        // Invalidate providers to refresh state across all screens
        ref.invalidate(tenantsProvider);
        ref.invalidate(tenantsStreamProvider);
        ref.invalidate(tenantProvider(tenantId));
        ref.invalidate(roomProvider(widget.roomId));
        ref.invalidate(allRoomsStreamProvider);
        ref.invalidate(propertiesStreamProvider);
        ref.invalidate(roomsForPropertyStreamProvider(widget.room.propertyId));
        ref.invalidate(dashboardSummaryProvider);

        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              totalFamily > 0
                  ? 'Tenant moved in with $totalFamily family member(s)'
                  : AppLocalizations.of(context)!.tenantMovedInSuccess,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.errorPrefix}$e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _emptyToNull(String text) => text.trim().isEmpty ? null : text.trim();

  Future<bool?> _showPartialFillDialog() {
    final missingFields = <String>[];
    if (_newFatherNameController.text.isEmpty) {
      missingFields.add('Father\'s Name');
    }
    if (_newPhoneController.text.isEmpty) {
      missingFields.add(AppLocalizations.of(context)!.phoneLabel);
    }
    if (_newAadharController.text.isEmpty) {
      missingFields.add(AppLocalizations.of(context)!.aadhaarNumber);
    }
    if (_addressLineController.text.isEmpty) {
      missingFields.add(AppLocalizations.of(context)!.permanentAddress);
    }
    if (_cityController.text.isEmpty) {
      missingFields.add(AppLocalizations.of(context)!.cityLabel);
    }
    if (_aadhaarFrontPath == null) {
      missingFields.add(AppLocalizations.of(context)!.aadhaarFrontPhoto);
    }
    if (_aadhaarBackPath == null) {
      missingFields.add(AppLocalizations.of(context)!.aadhaarBackPhoto);
    }

    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
                AppLocalizations.of(context)!.incompleteProfile,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${missingFields.length} fields are not filled',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              // Missing fields list
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: missingFields
                      .map(
                        (field) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  field,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                        AppLocalizations.of(context)!.completeLaterMsg,
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
                      child: Text(AppLocalizations.of(context)!.goBack),
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
                      child: Text(AppLocalizations.of(context)!.saveAnyway),
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
                AppLocalizations.of(context)!.addFamilyMember,
                style: Theme.of(
                  ctx,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.nameRequiredLabel,
                  prefixIcon: Icon(Icons.person_outline),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.relationshipRequiredLabel),
                      initialValue: relationship,
                      items: [
                        DropdownMenuItem(
                          value: 'spouse',
                          child: Text(AppLocalizations.of(context)!.spouse),
                        ),
                        DropdownMenuItem(
                          value: 'child',
                          child: Text(AppLocalizations.of(context)!.child),
                        ),
                        DropdownMenuItem(
                          value: 'parent',
                          child: Text(AppLocalizations.of(context)!.parent),
                        ),
                        DropdownMenuItem(
                          value: 'sibling',
                          child: Text(AppLocalizations.of(context)!.sibling),
                        ),
                        DropdownMenuItem(
                          value: 'other',
                          child: Text(
                            AppLocalizations.of(context)!.otherRelation,
                          ),
                        ),
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
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.ageLabel,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.genderLabel,
                      ),
                      initialValue: gender,
                      items: [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text(AppLocalizations.of(context)!.maleLabel),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text(
                            AppLocalizations.of(context)!.femaleLabel,
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'other',
                          child: Text(
                            AppLocalizations.of(context)!.otherRelation,
                          ),
                        ),
                      ],
                      onChanged: (v) => setLocalState(() => gender = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.phoneOptionalLabel,
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
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            relationship == null) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                )!.nameAndRelRequired,
                              ),
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
                      child: Text(AppLocalizations.of(context)!.addBtn),
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
    final tenantsAsync = ref.watch(tenantsProvider());

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
              AppLocalizations.of(context)!.moveInTenantTitle,
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
            label: AppLocalizations.of(context)!.newTenant,
            isSelected: _createNewTenant,
            onTap: () => setState(() {
              _createNewTenant = true;
              _selectedTenant = null;
              _selectedFamilyMemberIds.clear();
            }),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ToggleButton(
            label: AppLocalizations.of(context)!.existingTenant,
            isSelected: !_createNewTenant,
            onTap: () => setState(() {
              _createNewTenant = false;
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
        _buildSection(
          AppLocalizations.of(context)!.essentialInfo,
          Icons.person_outline,
          [
            TextFormField(
              controller: _newNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.fullNameRequiredLabel,
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  validateRequired(v, AppLocalizations.of(context)!, AppLocalizations.of(context)!.nameLabel),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newFatherNameController,
              decoration: InputDecoration(
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
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.ageLabel,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedGender,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.genderLabel,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'male',
                        child: Text(AppLocalizations.of(context)!.maleLabel),
                      ),
                      DropdownMenuItem(
                        value: 'female',
                        child: Text(AppLocalizations.of(context)!.femaleLabel),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text(
                          AppLocalizations.of(context)!.otherRelation,
                        ),
                      ),
                    ],
                    onChanged: (v) => setState(() => _selectedGender = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newPhoneController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.phoneLabel,
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newSecondaryPhoneController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.secondaryPhone,
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Permanent Address Section
        _buildSection(
          AppLocalizations.of(context)!.permanentAddress,
          Icons.home_outlined,
          [
            TextFormField(
              controller: _addressLineController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.addressLine,
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
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.cityLabel,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _stateController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.stateLabel,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pincodeController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.pincodeLabel,
                prefixIcon: Icon(Icons.pin_drop_outlined),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ID Documents Section
        _buildSection(
          AppLocalizations.of(context)!.idDocuments,
          Icons.badge_outlined,
          [
            TextFormField(
              controller: _newAadharController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.aadhaarNumber,
                hintText: AppLocalizations.of(context)!.twelveDigitNumberHint,
                prefixIcon: Icon(Icons.credit_card_outlined),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.aadhaarCardPhotos,
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
                      AppLocalizations.of(context)!.frontLabel,
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
                      AppLocalizations.of(context)!.backLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Work Details Section
        _buildSection(
          AppLocalizations.of(context)!.workDetails,
          Icons.work_outline,
          [
            TextFormField(
              controller: _companyNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.companyName,
                prefixIcon: Icon(Icons.business_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _officeAddressController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.officeAddress,
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
              maxLines: 2,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Introducer Section
        _buildSection('Introducer / Reference', Icons.handshake_outlined, [
          TextFormField(
            controller: _introducerNameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.introducerName,
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _introducerAddressController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.introducerAddress,
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _introducerPhoneController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.introducerPhone,
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
          ),
        ]),
        const SizedBox(height: 16),

        // Additional Documents Section
        Card(
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
                      AppLocalizations.of(context)!.additionalDocuments,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _pickDocument,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(AppLocalizations.of(context)!.addBtn),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_documents.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'No documents added yet.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _documents.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final doc = _documents[index];
                      final path = doc['path'] ?? '';
                      final isImage = path.toLowerCase().endsWith('.jpg') ||
                                      path.toLowerCase().endsWith('.jpeg') ||
                                      path.toLowerCase().endsWith('.png');
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: isImage
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(path),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 20),
                                  ),
                                )
                              : const Icon(Icons.description, size: 20),
                        ),
                        title: Text(
                          doc['title'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          path.split('/').last,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () => setState(() => _documents.removeAt(index)),
                        ),
                        onTap: () => FilePreviewDialog.show(context, path),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
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
                      AppLocalizations.of(context)!.familyMembers,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _showAddFamilyMemberDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(AppLocalizations.of(context)!.addBtn),
                ),
              ],
            ),
            if (_newFamilyMembers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  AppLocalizations.of(context)!.noFamilyMembersYet,
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
              AppLocalizations.of(context)!.selectTenant,
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
      error: (e, s) => Text('${AppLocalizations.of(context)!.errorPrefix}$e'),
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
        Text(AppLocalizations.of(context)!.moveInDetailsTitle, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 16),
        InkWell(
          onTap: _selectMoveInDate,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.moveInDateInputLabel,
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
                        AppLocalizations.of(context)!.futureLabel,
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
              labelText: AppLocalizations.of(context)!.startBillingFrom,
              prefixIcon: const Icon(Icons.receipt_long_outlined),
              helperText: AppLocalizations.of(context)!.billsNotTrackedMsg,
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
                        AppLocalizations.of(context)!.autoLabel,
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

        // Agreement End Date
        InkWell(
          onTap: _selectAgreementEndDate,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.agreementEndDateOptionalLabel,
              prefixIcon: const Icon(Icons.handshake_outlined),
              suffixIcon: _agreementEndDate == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => setState(() => _agreementEndDate = null),
                    ),
            ),
            child: Text(
              _agreementEndDate != null
                  ? '${_agreementEndDate!.day}/${_agreementEndDate!.month}/${_agreementEndDate!.year}'
                  : AppLocalizations.of(context)!.noAgreementDateSet,
              style: TextStyle(
                color: _agreementEndDate == null
                    ? Theme.of(context).hintColor
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _rentController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.agreedRentLabel,
            prefixIcon: const Icon(Icons.currency_rupee),
            helperText: 'Base: ${formatCurrency(widget.room.baseRent)}',
          ),
          keyboardType: TextInputType.number,
          validator: (v) =>
              validatePositiveNumber(v, AppLocalizations.of(context)!),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _depositController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.securityDepositLabel,
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
                      AppLocalizations.of(context)!.familyMembers,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onAddNew,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(AppLocalizations.of(context)!.addNewBtn),
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
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = AppColors.primaryOf(context);
    final outlineColor = AppColors.outlineOf(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : null,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: outlineColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : primaryColor,
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
            : Text(AppLocalizations.of(context)!.pastTenant),
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
