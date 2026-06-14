/// Edit profile screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/dashboard_providers.dart';

import '../../../core/utils/validators.dart';
import '../../../domain/entities/landlord.dart';
import '../../widgets/image_picker_widget.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

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
      _photoPath = landlord.photoPath;
      _initialized = true;
    }
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.profileUpdated)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.errorPrefix}$e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final landlordAsync = ref.watch(landlordProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfile)),
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
                  child: Hero(
                    tag: 'landlord_profile_photo',
                    child: ImagePickerWidget(
                      initialImagePath: _photoPath,
                      placeholderIcon: Icons.person,
                      size: 100,
                      onImageSelected: (path) =>
                          setState(() => _photoPath = path),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.yourName,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (v) => validateRequired(v, l10n.nameLabel),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: l10n.phoneLabel,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    hintText: l10n.mobileNumberHint,
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
                  decoration: InputDecoration(
                    labelText: l10n.upiId,
                    prefixIcon: const Icon(
                      Icons.account_balance_wallet_outlined,
                    ),
                    hintText: l10n.upiIdHint,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    return validateUpiId(v);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.upiInvoiceHelperText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 32),

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
                        : Text(l10n.saveProfile),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('${l10n.errorPrefix}$e')),
      ),
    );
  }
}
