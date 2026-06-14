/// Add/Edit tenant screen with comprehensive profile fields.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/tenant_providers.dart';

import '../../../core/utils/validators.dart';
import '../../../domain/entities/tenant.dart';
import 'package:rent_khata/l10n/app_localizations.dart';
import '../../widgets/image_picker_widget.dart';

/// Screen to add or edit a tenant with comprehensive profile.
class AddTenantScreen extends ConsumerStatefulWidget {
  final Tenant? tenant;

  const AddTenantScreen({super.key, this.tenant});

  @override
  ConsumerState<AddTenantScreen> createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends ConsumerState<AddTenantScreen> {
  final _formKey = GlobalKey<FormState>();

  // Identity & Contact
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _secondaryPhoneController = TextEditingController();
  final _aadharController = TextEditingController();
  String? _selectedGender;

  // Permanent Address
  final _addressLineController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  // Work Details
  final _companyNameController = TextEditingController();
  final _officeAddressController = TextEditingController();

  // Introducer/Reference
  final _introducerNameController = TextEditingController();
  final _introducerAddressController = TextEditingController();
  final _introducerPhoneController = TextEditingController();

  // Photos
  String? _photoPath;
  String? _aadhaarFrontPath;
  String? _aadhaarBackPath;

  // Police Verification
  bool _isPoliceVerified = false;

  // Documents
  final List<Map<String, String>> _documents = []; // {path, title}

  bool _isLoading = false;

  bool get isEditing => widget.tenant != null;

  @override
  void initState() {
    super.initState();
    if (widget.tenant != null) {
      _populateFromTenant(widget.tenant!);
    }
  }
  // ... (omitted methods)

  Future<void> _pickDocument() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (!mounted) return;
      final titleController = TextEditingController();
      final title = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          title: Text(AppLocalizations.of(context)!.documentTitleLabel),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'e.g. PAN Card'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancelBtn),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, titleController.text),
              child: Text(AppLocalizations.of(context)!.addBtn),
            ),
          ],
        ),
      );

      if (title != null && title.isNotEmpty) {
        setState(() {
          _documents.add({'path': pickedFile.path, 'title': title});
        });
      }
    }
  }

  Future<void> _saveDocuments(int tenantId) async {
    final repo = ref.read(tenantRepositoryProvider);
    for (final doc in _documents) {
      await repo.addDocument(
        tenantId: tenantId,
        title: doc['title']!,
        filePath: doc['path']!,
        fileType: 'image',
      );
    }
  }

  void _populateFromTenant(Tenant tenant) {
    _nameController.text = tenant.name;
    _fatherNameController.text = tenant.fatherName ?? '';
    _ageController.text = tenant.age?.toString() ?? '';
    _phoneController.text = tenant.phone ?? '';
    _secondaryPhoneController.text = tenant.secondaryPhone ?? '';
    _aadharController.text = tenant.aadharNumber ?? '';
    _selectedGender = tenant.gender;

    _addressLineController.text = tenant.permanentAddressLine ?? '';
    _cityController.text = tenant.permanentCity ?? '';
    _stateController.text = tenant.permanentState ?? '';
    _pincodeController.text = tenant.permanentPincode ?? '';

    _companyNameController.text = tenant.companyName ?? '';
    _officeAddressController.text = tenant.officeAddress ?? '';

    _introducerNameController.text = tenant.introducerName ?? '';
    _introducerAddressController.text = tenant.introducerAddress ?? '';
    _introducerPhoneController.text = tenant.introducerPhone ?? '';

    _photoPath = tenant.photoPath;
    _aadhaarFrontPath = tenant.aadhaarFrontPhotoPath;
    _aadhaarBackPath = tenant.aadhaarBackPhotoPath;
    _isPoliceVerified = tenant.isPoliceVerified;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _secondaryPhoneController.dispose();
    _aadharController.dispose();
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

  Future<void> _saveTenant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    try {
      final repo = ref.read(tenantRepositoryProvider);

      int tenantId;
      if (isEditing) {
        tenantId = widget.tenant!.id;
        await repo.updateTenant(
          widget.tenant!.copyWith(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
            aadharNumber: _aadharController.text.trim().isEmpty
                ? null
                : _aadharController.text.trim(),
            isPoliceVerified: _isPoliceVerified,
            photoPath: _photoPath,
            fatherName: _fatherNameController.text.trim().isEmpty
                ? null
                : _fatherNameController.text.trim(),
            age: int.tryParse(_ageController.text),
            gender: _selectedGender,
            secondaryPhone: _secondaryPhoneController.text.trim().isEmpty
                ? null
                : _secondaryPhoneController.text.trim(),
            permanentAddressLine: _addressLineController.text.trim().isEmpty
                ? null
                : _addressLineController.text.trim(),
            permanentCity: _cityController.text.trim().isEmpty
                ? null
                : _cityController.text.trim(),
            permanentState: _stateController.text.trim().isEmpty
                ? null
                : _stateController.text.trim(),
            permanentPincode: _pincodeController.text.trim().isEmpty
                ? null
                : _pincodeController.text.trim(),
            companyName: _companyNameController.text.trim().isEmpty
                ? null
                : _companyNameController.text.trim(),
            officeAddress: _officeAddressController.text.trim().isEmpty
                ? null
                : _officeAddressController.text.trim(),
            aadhaarFrontPhotoPath: _aadhaarFrontPath,
            aadhaarBackPhotoPath: _aadhaarBackPath,
            introducerName: _introducerNameController.text.trim().isEmpty
                ? null
                : _introducerNameController.text.trim(),
            introducerAddress: _introducerAddressController.text.trim().isEmpty
                ? null
                : _introducerAddressController.text.trim(),
            introducerPhone: _introducerPhoneController.text.trim().isEmpty
                ? null
                : _introducerPhoneController.text.trim(),
          ),
        );
      } else {
        tenantId = await repo.createTenant(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          aadharNumber: _aadharController.text.trim().isEmpty
              ? null
              : _aadharController.text.trim(),
          isPoliceVerified: _isPoliceVerified,
          photoPath: _photoPath,
          fatherName: _fatherNameController.text.trim().isEmpty
              ? null
              : _fatherNameController.text.trim(),
          age: int.tryParse(_ageController.text),
          gender: _selectedGender,
          secondaryPhone: _secondaryPhoneController.text.trim().isEmpty
              ? null
              : _secondaryPhoneController.text.trim(),
          permanentAddressLine: _addressLineController.text.trim().isEmpty
              ? null
              : _addressLineController.text.trim(),
          permanentCity: _cityController.text.trim().isEmpty
              ? null
              : _cityController.text.trim(),
          permanentState: _stateController.text.trim().isEmpty
              ? null
              : _stateController.text.trim(),
          permanentPincode: _pincodeController.text.trim().isEmpty
              ? null
              : _pincodeController.text.trim(),
          companyName: _companyNameController.text.trim().isEmpty
              ? null
              : _companyNameController.text.trim(),
          officeAddress: _officeAddressController.text.trim().isEmpty
              ? null
              : _officeAddressController.text.trim(),
          aadhaarFrontPhotoPath: _aadhaarFrontPath,
          aadhaarBackPhotoPath: _aadhaarBackPath,
          introducerName: _introducerNameController.text.trim().isEmpty
              ? null
              : _introducerNameController.text.trim(),
          introducerAddress: _introducerAddressController.text.trim().isEmpty
              ? null
              : _introducerAddressController.text.trim(),
          introducerPhone: _introducerPhoneController.text.trim().isEmpty
              ? null
              : _introducerPhoneController.text.trim(),
        );
      }

      // Save documents
      if (_documents.isNotEmpty) {
        await _saveDocuments(tenantId);
      }

      // Invalidate tenant providers to refresh data
      ref.invalidate(tenantsProvider);
      if (isEditing) {
        ref.invalidate(tenantProvider(widget.tenant!.id));
      }

      if (mounted) {
        context.pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? AppLocalizations.of(context)!.tenantUpdatedSuccess : AppLocalizations.of(context)!.tenantAddedSuccess),
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
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? AppLocalizations.of(context)!.editTenantTitle : AppLocalizations.of(context)!.addTenantTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Photo
            _buildProfilePhotoSection(),
            const SizedBox(height: 24),

            // Identity & Contact Section
            _buildSectionCard(
              title: AppLocalizations.of(context)!.identityContactTitle,
              icon: Icons.person_outline,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.fullNameRequiredLabel,
                    hintText: AppLocalizations.of(context)!.enterTenantFullNameHint,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => validateRequired(v, 'Name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fatherNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.guardianNameOptionalLabel,
                    hintText: AppLocalizations.of(context)!.fathersNameRequiredHint,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.ageLabel,
                          prefixIcon: Icon(Icons.cake_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _selectedGender,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.genderLabel,
                          prefixIcon: Icon(Icons.wc_outlined),
                        ),
                        items: [
                          DropdownMenuItem(value: 'male', child: Text(AppLocalizations.of(context)!.maleLabel)),
                          DropdownMenuItem(
                            value: 'female',
                            child: Text(AppLocalizations.of(context)!.femaleLabel),
                          ),
                          DropdownMenuItem(
                            value: 'other',
                            child: Text(AppLocalizations.of(context)!.otherLabel),
                          ),
                        ],
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.phoneOptionalLabel,
                    hintText: AppLocalizations.of(context)!.tenDigitMobileHint,
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      v?.isEmpty ?? true ? null : validatePhone(v),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _secondaryPhoneController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.secondaryPhoneLabel,
                    hintText: AppLocalizations.of(context)!.emergencyFamilyContactHint,
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Permanent Address Section
            _buildSectionCard(
              title: AppLocalizations.of(context)!.permanentAddressTitle,
              icon: Icons.home_outlined,
              children: [
                TextFormField(
                  controller: _addressLineController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.addressLineLabel,
                    hintText: AppLocalizations.of(context)!.streetLocalityHint,
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
labelText: AppLocalizations.of(context)!.cityLabel),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: InputDecoration(
labelText: AppLocalizations.of(context)!.stateLabel),
                        textCapitalization: TextCapitalization.words,
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Work Details Section
            _buildSectionCard(
              title: AppLocalizations.of(context)!.workDetailsTitle,
              icon: Icons.work_outline,
              children: [
                TextFormField(
                  controller: _companyNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.companyNameLabel,
                    prefixIcon: Icon(Icons.business_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _officeAddressController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.officeAddressLabel,
                    prefixIcon: Icon(Icons.location_city_outlined),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ID Documents Section
            _buildSectionCard(
              title: AppLocalizations.of(context)!.idDocumentsTitle,
              icon: Icons.badge_outlined,
              children: [
                TextFormField(
                  controller: _aadharController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.aadhaarNumberLabel,
                    hintText: AppLocalizations.of(context)!.twelveDigitAadhaarHint,
                    prefixIcon: Icon(Icons.credit_card_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: validateAadhar,
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.aadhaarCardPhotosLabel,
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
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
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
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Introducer/Reference Section
            _buildSectionCard(
              title: AppLocalizations.of(context)!.introducerReferenceTitle,
              icon: Icons.handshake_outlined,
              children: [
                TextFormField(
                  controller: _introducerNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.introducerNameLabel,
                    hintText: AppLocalizations.of(context)!.vouchedForTenantHint,
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _introducerAddressController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.introducerAddressLabel,
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _introducerPhoneController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.introducerPhoneLabel,
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Police Verification Section
            Card(
              child: SwitchListTile(
                title: Text(AppLocalizations.of(context)!.policeVerifiedLabel),
                subtitle: Text(AppLocalizations.of(context)!.policeVerifiedSubtitle),
                secondary: Icon(
                  _isPoliceVerified
                      ? Icons.verified_user
                      : Icons.verified_user_outlined,
                  color: _isPoliceVerified
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                value: _isPoliceVerified,
                onChanged: (v) => setState(() => _isPoliceVerified = v),
              ),
            ),
            const SizedBox(height: 16),

            // Additional Documents Section
            _buildSectionCard(
              title: AppLocalizations.of(context)!.additionalDocumentsTitle,
              icon: Icons.folder_outlined,
              children: [
                if (_documents.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      AppLocalizations.of(context)!.noDocumentsAddedYet,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ..._documents.asMap().entries.map((entry) {
                  final index = entry.key;
                  final doc = entry.value;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.description_outlined),
                    title: Text(doc['title'] ?? ''),
                    subtitle: Text(
                      doc['path']?.split('/').last ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () =>
                          setState(() => _documents.removeAt(index)),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _pickDocument,
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context)!.addDocumentBtn),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveTenant,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(isEditing ? AppLocalizations.of(context)!.saveChangesBtn : AppLocalizations.of(context)!.addTenantTitle),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return Center(
      child: Column(
        children: [
          ImagePickerWidget(
            initialImagePath: _photoPath,
            placeholderIcon: Icons.person,
            size: 120,
            onImageSelected: (path) => setState(() => _photoPath = path),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.profilePhotoLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
}
