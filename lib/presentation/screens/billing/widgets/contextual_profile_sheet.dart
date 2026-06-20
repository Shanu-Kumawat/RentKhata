import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../application/providers/repository_providers.dart';
import '../../../../application/providers/dashboard_providers.dart';
import '../../../../core/utils/validators.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

/// Contextual bottom sheet to collect Landlord Name & UPI before generating first bill.
class ContextualProfileSheet extends ConsumerStatefulWidget {
  const ContextualProfileSheet({super.key});

  /// Shows the bottom sheet if Name or UPI are missing, and returns `true` if they exist or get created.
  static Future<bool> ensureProfile(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(landlordRepositoryProvider);
    final landlord = await repo.getLandlord();

    // We already have name. Proceed (UPI is optional).
    if (landlord != null && landlord.name.isNotEmpty) {
      return true;
    }

    if (!context.mounted) return false;

    // Show the contextual modal to collect
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const ContextualProfileSheet(),
    );

    return result ?? false;
  }

  @override
  ConsumerState<ContextualProfileSheet> createState() =>
      _ContextualProfileSheetState();
}

class _ContextualProfileSheetState
    extends ConsumerState<ContextualProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _upiController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    final repo = ref.read(landlordRepositoryProvider);
    final landlord = await repo.getLandlord();
    if (landlord != null) {
      _nameController.text = landlord.name;
      _phoneController.text = landlord.phone ?? '';
      _upiController.text = landlord.upiId ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(landlordRepositoryProvider);
      final existing = await repo.getLandlord();

      await repo.upsertLandlord(
        name: _nameController.text.trim(),
        upiId: _upiController.text.trim(),
        phone: _phoneController.text.trim(),
        photoPath: existing?.photoPath,
      );

      ref.invalidate(landlordProvider);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.errorPrefix}$e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, bottomInset + 32),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.5,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                ).animate().scale(
                  delay: 100.ms,
                  begin: const Offset(0, 0),
                  curve: Curves.easeOutBack,
                ),

                const SizedBox(height: 16),

                Text(
                  AppLocalizations.of(context)!.letsMakeItProfessionalTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

                const SizedBox(height: 8),

                Text(
                  AppLocalizations.of(context)!.addNameUpiSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

                const SizedBox(height: 32),

                // Inputs
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.yourNameBusinessNameLabel,
                    prefixIcon: const Icon(Icons.business_center_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                  ),
                  validator: (v) => v == null || v.isEmpty
                      ? 'Required to generate bills'
                      : null,
                  textInputAction: TextInputAction.next,
                ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.phoneOptionalLabel,
                    hintText: AppLocalizations.of(context)!.phoneNumberHint,
                    prefixIcon: const Icon(Icons.phone_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    helperText: AppLocalizations.of(context)!.phonePdfExplanation,
                    helperMaxLines: 3,
                    helperStyle: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      height: 1.2,
                    ),
                  ),
                  validator: (v) {
                    if (v != null && v.trim().isNotEmpty) {
                      final cleaned = v.replaceAll(RegExp(r'[\s-]'), '');
                      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned)) {
                        return AppLocalizations.of(context)!.validatePhoneInvalid;
                      }
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ).animate().fadeIn(delay: 450.ms).slideX(begin: 0.1),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _upiController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.upiIdOptionalLabel,
                    hintText: AppLocalizations.of(context)!.upiIdHint,
                    prefixIcon: const Icon(Icons.qr_code_2_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    helperText: AppLocalizations.of(context)!.upiInvoiceHelperText,
                    helperMaxLines: 5,
                    helperStyle: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      height: 1.2,
                    ),
                  ),
                  validator: (v) => validateUpiId(v, AppLocalizations.of(context)!),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _saveProfile(),
                ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),

                const SizedBox(height: 32),

                // Submit Button
                FilledButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Continue to Bill',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
