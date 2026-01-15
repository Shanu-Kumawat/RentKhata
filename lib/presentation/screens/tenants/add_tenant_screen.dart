/// Add/Edit tenant screen with comprehensive profile fields.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/tenant.dart';
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

  bool _isLoading = false;

  bool get isEditing => widget.tenant != null;

  @override
  void initState() {
    super.initState();
    if (widget.tenant != null) {
      _populateFromTenant(widget.tenant!);
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

      if (isEditing) {
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
        await repo.createTenant(
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

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Tenant updated' : 'Tenant added'),
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
      appBar: AppBar(title: Text(isEditing ? 'Edit Tenant' : 'Add Tenant')),
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
              title: 'Identity & Contact',
              icon: Icons.person_outline,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    hintText: 'Enter tenant\'s full name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => validateRequired(v, 'Name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fatherNameController,
                  decoration: const InputDecoration(
                    labelText: 'Father\'s Name',
                    hintText: 'Required for legal agreements',
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
                        decoration: const InputDecoration(
                          labelText: 'Age',
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
                        value: _selectedGender,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: Icon(Icons.wc_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'male', child: Text('Male')),
                          DropdownMenuItem(
                            value: 'female',
                            child: Text('Female'),
                          ),
                          DropdownMenuItem(
                            value: 'other',
                            child: Text('Other'),
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
                  decoration: const InputDecoration(
                    labelText: 'Phone Number *',
                    hintText: '10-digit mobile number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      v?.isEmpty ?? true ? null : validatePhone(v),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _secondaryPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Secondary Phone',
                    hintText: 'Emergency/Family contact',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Permanent Address Section
            _buildSectionCard(
              title: 'Permanent Address',
              icon: Icons.home_outlined,
              children: [
                TextFormField(
                  controller: _addressLineController,
                  decoration: const InputDecoration(
                    labelText: 'Address Line',
                    hintText: 'Street, Locality',
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
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: const InputDecoration(labelText: 'State'),
                        textCapitalization: TextCapitalization.words,
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Work Details Section
            _buildSectionCard(
              title: 'Work Details',
              icon: Icons.work_outline,
              children: [
                TextFormField(
                  controller: _companyNameController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                    prefixIcon: Icon(Icons.business_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
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
              ],
            ),
            const SizedBox(height: 16),

            // ID Documents Section
            _buildSectionCard(
              title: 'ID Documents',
              icon: Icons.badge_outlined,
              children: [
                TextFormField(
                  controller: _aadharController,
                  decoration: const InputDecoration(
                    labelText: 'Aadhaar Number',
                    hintText: '12-digit Aadhaar number',
                    prefixIcon: Icon(Icons.credit_card_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: validateAadhar,
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
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceVariant),
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
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceVariant),
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
              title: 'Introducer / Reference',
              icon: Icons.handshake_outlined,
              children: [
                TextFormField(
                  controller: _introducerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Introducer Name',
                    hintText: 'Person who vouched for tenant',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
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
              ],
            ),
            const SizedBox(height: 16),

            // Police Verification Section
            Card(
              child: SwitchListTile(
                title: const Text('Police Verified'),
                subtitle: const Text('Mark if police verification is complete'),
                secondary: Icon(
                  _isPoliceVerified
                      ? Icons.verified_user
                      : Icons.verified_user_outlined,
                  color: _isPoliceVerified
                      ? AppColors.success
                      : AppColors.onSurfaceVariant,
                ),
                value: _isPoliceVerified,
                onChanged: (v) => setState(() => _isPoliceVerified = v),
              ),
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
                    : Text(isEditing ? 'Save Changes' : 'Add Tenant'),
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
            'Profile Photo',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
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
                Icon(icon, color: AppColors.primary, size: 20),
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
