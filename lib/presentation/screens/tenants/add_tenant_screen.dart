/// Add/Edit tenant screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/tenant.dart';

/// Screen to add or edit a tenant.
class AddTenantScreen extends ConsumerStatefulWidget {
  final Tenant? tenant;

  const AddTenantScreen({super.key, this.tenant});

  @override
  ConsumerState<AddTenantScreen> createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends ConsumerState<AddTenantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aadharController = TextEditingController();
  bool _isPoliceVerified = false;
  bool _isLoading = false;

  bool get isEditing => widget.tenant != null;

  @override
  void initState() {
    super.initState();
    if (widget.tenant != null) {
      _nameController.text = widget.tenant!.name;
      _phoneController.text = widget.tenant!.phone ?? '';
      _aadharController.text = widget.tenant!.aadharNumber ?? '';
      _isPoliceVerified = widget.tenant!.isPoliceVerified;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _aadharController.dispose();
    super.dispose();
  }

  Future<void> _saveTenant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Tenant' : 'Add Tenant'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile photo
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  hintText: 'Tenant\'s full name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) => validateRequired(v, 'Name'),
              ),
              const SizedBox(height: 20),

              // Phone
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '10-digit mobile number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v?.isEmpty ?? true ? null : validatePhone(v),
              ),
              const SizedBox(height: 20),

              // Aadhar
              TextFormField(
                controller: _aadharController,
                decoration: const InputDecoration(
                  labelText: 'Aadhar Number',
                  hintText: '12-digit Aadhar number',
                  prefixIcon: Icon(Icons.credit_card_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: validateAadhar,
              ),
              const SizedBox(height: 20),

              // Police Verification toggle
              Card(
                child: SwitchListTile(
                  title: const Text('Police Verified'),
                  subtitle: const Text('Mark if police verification is done'),
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
              const SizedBox(height: 40),

              // Save button
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
            ],
          ),
        ),
      ),
    );
  }
}
