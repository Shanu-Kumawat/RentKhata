/// Edit profile screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/dashboard_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/landlord.dart';
import '../../widgets/image_picker_widget.dart';

/// Screen to edit landlord profile.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _upiController = TextEditingController();
  String? _photoPath;
  bool _isLoading = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  void _initializeFromLandlord(Landlord? landlord) {
    if (landlord != null && !_initialized) {
      _nameController.text = landlord.name;
      _phoneController.text = landlord.phone ?? '';
      _upiController.text = landlord.upiId ?? '';
      _photoPath = landlord.photoPath;
      _initialized = true;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(landlordRepositoryProvider);
      final existingLandlord = await repo.getLandlord();
      
      if (existingLandlord != null) {
        await repo.updateLandlord(
          existingLandlord.copyWith(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
            upiId: _upiController.text.trim().isEmpty
                ? null
                : _upiController.text.trim(),
            photoPath: _photoPath,
          ),
        );
      }

      ref.invalidate(landlordProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
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
    final landlordAsync = ref.watch(landlordProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: landlordAsync.when(
        data: (landlord) {
          _initializeFromLandlord(landlord);
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Avatar
                Center(
                  child: ImagePickerWidget(
                    initialImagePath: _photoPath,
                    placeholderIcon: Icons.person,
                    size: 100,
                    onImageSelected: (path) => setState(() => _photoPath = path),
                  ),
                ),
                const SizedBox(height: 32),

                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name *',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) => validateRequired(v, 'Name'),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                    hintText: '10-digit mobile number',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    return validatePhone(v);
                  },
                ),
                const SizedBox(height: 16),

                // UPI ID
                TextFormField(
                  controller: _upiController,
                  decoration: const InputDecoration(
                    labelText: 'UPI ID',
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                    hintText: 'yourname@upi',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    return validateUpiId(v);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Your UPI ID is used to generate QR codes for rent collection.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Save Profile'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
