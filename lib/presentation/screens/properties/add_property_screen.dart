/// Add/Edit property screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/property.dart';
import '../../widgets/image_picker_widget.dart';

/// Screen to add or edit a property.
class AddPropertyScreen extends ConsumerStatefulWidget {
  final Property? property; // null for add, non-null for edit

  const AddPropertyScreen({super.key, this.property});

  @override
  ConsumerState<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends ConsumerState<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String? _photoPath;
  bool _isLoading = false;

  bool get isEditing => widget.property != null;

  @override
  void initState() {
    super.initState();
    if (widget.property != null) {
      _nameController.text = widget.property!.name;
      _addressController.text = widget.property!.address ?? '';
      _photoPath = widget.property!.photoPath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProperty() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(propertyRepositoryProvider);

      if (isEditing) {
        await repo.updateProperty(
          widget.property!.copyWith(
            name: _nameController.text.trim(),
            address: _addressController.text.trim().isEmpty
                ? null
                : _addressController.text.trim(),
            photoPath: _photoPath,
          ),
        );
      } else {
        await repo.createProperty(
          name: _nameController.text.trim(),
          address: _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
          photoPath: _photoPath,
        );
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Property updated' : 'Property added',
            ),
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
        title: Text(isEditing ? 'Edit Property' : 'Add Property'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property photo
              Center(
                child: ImagePickerWidget(
                  initialImagePath: _photoPath,
                  placeholderIcon: Icons.apartment_rounded,
                  onImageSelected: (path) => setState(() => _photoPath = path),
                ),
              ),
              const SizedBox(height: 32),

              // Property name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Property Name *',
                  hintText: 'e.g., Sunrise Apartments',
                  prefixIcon: Icon(Icons.home_work_outlined),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) => validateRequired(v, 'Property name'),
              ),
              const SizedBox(height: 20),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Full address of the property',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
              ),
              const SizedBox(height: 40),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProperty,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(isEditing ? 'Save Changes' : 'Add Property'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
