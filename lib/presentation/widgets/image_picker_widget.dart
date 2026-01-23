/// Reusable image picker widget.
library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/image_service.dart';

class ImagePickerWidget extends StatefulWidget {
  final String? initialImagePath;
  final Function(String?) onImageSelected;
  final IconData placeholderIcon;
  final double size;

  const ImagePickerWidget({
    super.key,
    this.initialImagePath,
    required this.onImageSelected,
    this.placeholderIcon = Icons.photo_camera,
    this.size = 120,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String? _currentImagePath;
  final _imageService = ImageService();

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.initialImagePath;
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _imageService.pickImage(source: source);
    if (file != null) {
      if (_currentImagePath != null) {
        // Optionally delete old image if needed, but for now we keep history
        // await _imageService.deleteImage(_currentImagePath!);
      }

      setState(() => _currentImagePath = file.path);
      widget.onImageSelected(file.path);
    }
  }

  void _showSourceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_currentImagePath != null)
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Remove Photo',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _currentImagePath = null);
                  widget.onImageSelected(null);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showSourceSelector,
      child: Stack(
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                widget.size / 4,
              ), // Rounded square
              image: _currentImagePath != null
                  ? DecorationImage(
                      image: FileImage(File(_currentImagePath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _currentImagePath == null
                ? Icon(
                    widget.placeholderIcon,
                    size: widget.size * 0.4,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
