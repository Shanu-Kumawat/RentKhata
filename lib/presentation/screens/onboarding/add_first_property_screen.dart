/// Add first property screen during onboarding.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/utils/validators.dart';

/// Screen to add the first property during onboarding.
class AddFirstPropertyScreen extends ConsumerStatefulWidget {
  const AddFirstPropertyScreen({super.key});

  @override
  ConsumerState<AddFirstPropertyScreen> createState() =>
      _AddFirstPropertyScreenState();
}

class _AddFirstPropertyScreenState
    extends ConsumerState<AddFirstPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isLoading = false;
  bool _isSuccess = false;

  final List<String> _suggestions = [
    'PG Hostel',
    'Apartment Block',
    'Commercial Shop',
    'Residential',
  ];

  @override
  void initState() {
    super.initState();
    // Auto-focus the input field as a speed-to-value optimization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Delay focus slightly so the enter animation is smooth before keyboard pops
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _focusNode.requestFocus();
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
  }

  Future<void> _saveProperty() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(propertyRepositoryProvider);
      await repo.createProperty(
        name: _nameController.text.trim(),
        address: null, // Removed for speed
      );

      await _markOnboardingComplete();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });

        // Brief success animation state before routing
        await Future.delayed(const Duration(milliseconds: 800));

        if (mounted) {
          context.go('/dashboard');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding property: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _skipForNow() async {
    await _markOnboardingComplete();
    if (mounted) {
      context.go('/dashboard');
    }
  }

  void _applySuggestion(String suggestion) {
    _nameController.text = suggestion;
    // Move cursor to end
    _nameController.selection = TextSelection.fromPosition(
      TextPosition(offset: _nameController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _skipForNow,
            child: Text(
              'Skip for now',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ).animate().fadeIn(delay: 800.ms),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Sequence
                Text(
                      'What are you managing?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
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

                const SizedBox(height: 12),

                Text(
                      'Give your first property or building a name.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      curve: Curves.easeOutCubic,
                      duration: 400.ms,
                    ),

                const SizedBox(height: 48),

                // Property name field
                Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        focusNode: _focusNode,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Property Name',
                          hintText: 'e.g., Green Valley Apartments',
                          labelStyle: GoogleFonts.inter(),
                          hintStyle: GoogleFonts.inter(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.apartment_rounded,
                            color: colorScheme.primary,
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => validateRequired(v, 'Property name'),
                        onFieldSubmitted: (_) => _saveProperty(),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 400.ms)
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      curve: Curves.easeOutCubic,
                      duration: 400.ms,
                    ),

                const SizedBox(height: 24),

                // Suggestions wrapping
                Wrap(
                      spacing: 10,
                      runSpacing: 12,
                      children: _suggestions.map((suggestion) {
                        return ActionChip(
                          label: Text(
                            suggestion,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () => _applySuggestion(suggestion),
                          backgroundColor: colorScheme.surfaceContainerHigh
                              .withValues(alpha: 0.5),
                          side: BorderSide(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.2,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }).toList(),
                    )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms)
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      curve: Curves.easeOutCubic,
                      duration: 400.ms,
                    ),

                const SizedBox(height: 64),

                // Animated Button
                SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: _isSuccess
                              ? Colors.green
                              : colorScheme.primary,
                        ),
                        onPressed: (_isLoading || _isSuccess)
                            ? null
                            : _saveProperty,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: _isSuccess
                              ? const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.white,
                                  size: 32,
                                  key: ValueKey('success'),
                                )
                              : _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  key: ValueKey('loading'),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Continue',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                  ),
                                  key: const ValueKey('text'),
                                ),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 400.ms)
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      curve: Curves.easeOutCubic,
                      duration: 400.ms,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
