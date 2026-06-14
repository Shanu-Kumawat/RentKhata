/// Profile setup screen for landlord details.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../application/providers/repository_providers.dart';

import '../../../core/utils/validators.dart';
import '../../widgets/image_picker_widget.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

/// Profile setup screen for landlord to enter their details.
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _upiController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _photoPath;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _upiController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(landlordRepositoryProvider);
      await repo.upsertLandlord(
        name: _nameController.text.trim(),
        upiId: _upiController.text.trim().isEmpty
            ? null
            : _upiController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        photoPath: _photoPath,
      );

      if (mounted) {
        context.go('/add-first-property');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.yourProfileTitle),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                    AppLocalizations.of(context)!.letsSetUpProfile,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    curve: Curves.easeOutCubic,
                    duration: 400.ms,
                  ),
              const SizedBox(height: 8),
              Text(
                    AppLocalizations.of(context)!.profileBillingInfoText,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    curve: Curves.easeOutCubic,
                    duration: 400.ms,
                  ),
              const SizedBox(height: 32),

              // Profile photo placeholder
              Center(
                child: ImagePickerWidget(
                  initialImagePath: _photoPath,
                  placeholderIcon: Icons.person,
                  size: 100,
                  onImageSelected: (path) => setState(() => _photoPath = path),
                ),
              ).animate().scale(
                delay: 200.ms,
                duration: 400.ms,
                curve: Curves.easeOutBack,
              ),
              const SizedBox(height: 32),

              // Name field
              TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.yourNameLabel,
                      hintText: AppLocalizations.of(context)!.enterFullNameHint,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => validateRequired(v, 'Name'),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms)
                  .slideX(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 20),

              // Phone field
              TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.phoneNumberLabel,
                      hintText: AppLocalizations.of(context)!.phoneNumberHint,
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v?.isEmpty ?? true ? null : validatePhone(v),
                  )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 400.ms)
                  .slideX(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 20),

              // UPI field
              TextFormField(
                    controller: _upiController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.upiIdLabel,
                      hintText: AppLocalizations.of(context)!.upiIdHint,
                      prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                      helperText: AppLocalizations.of(context)!.upiHelperText,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: validateUpiId,
                  )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 400.ms)
                  .slideX(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 40),

              // Info card
              Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.profileUpiInfoText,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 40),

              // Continue button
              SizedBox(
                    width: double.infinity,
                    height: 56,
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
                          : Text(
                              AppLocalizations.of(context)!.continueBtn,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 400.ms)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
