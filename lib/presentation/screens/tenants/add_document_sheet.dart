import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../services/image_service.dart';
import '../../../application/providers/repository_providers.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

class AddDocumentSheet extends ConsumerStatefulWidget {
  final int tenantId;

  const AddDocumentSheet({super.key, required this.tenantId});

  @override
  ConsumerState<AddDocumentSheet> createState() => _AddDocumentSheetState();
}

class _AddDocumentSheetState extends ConsumerState<AddDocumentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  File? _selectedFile;
  String _fileType = 'image'; // 'image' or 'pdf'
  final _picker = ImagePicker();
  bool _isSaving = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        _fileType = 'image';
      });
    }
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileType = 'pdf';
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.selectDocumentError)));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final imageService = ImageService();
      final persistentFileName = await imageService.saveFileToAppDirectory(
        _selectedFile!,
        isImage: _fileType == 'image',
      );

      if (persistentFileName == null) {
        throw Exception('Failed to save document file securely.');
      }
      await ref
          .read(tenantRepositoryProvider)
          .addDocument(
            tenantId: widget.tenantId,
            title: _titleController.text.trim(),
            filePath: persistentFileName,
            fileType: _fileType,
          );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.errorPrefix}$e')));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.addDocumentTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.documentTitleLabel,
                hintText: AppLocalizations.of(context)!.documentTitleHint,
                prefixIcon: const Icon(Icons.description_outlined),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _showSourceSheet(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                child: _selectedFile != null
                    ? _buildPreview()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.tapToAddDocument,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.imageOrPdf,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(AppLocalizations.of(context)!.saveDocumentBtn),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _fileType == 'pdf'
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      size: 48,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedFile!.path.split('/').last,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              : Image.file(
                  _selectedFile!,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton.filled(
            icon: const Icon(Icons.edit),
            onPressed: _showSourceSheet,
          ),
        ),
      ],
    );
  }

  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.picture_as_pdf, color: Colors.red.shade400),
              title: Text(AppLocalizations.of(context)!.selectPdf),
              onTap: () {
                Navigator.pop(context);
                _pickPdf();
              },
            ),
          ],
        ),
      ),
    );
  }
}
