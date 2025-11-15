import 'dart:io';
import 'package:flutter/material.dart';

/// Widget for picking and displaying pet photos.
class PhotoPicker extends StatelessWidget {
  final String? photoPath;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback? onRemove;
  final double size;

  const PhotoPicker({
    super.key,
    this.photoPath,
    required this.onCamera,
    required this.onGallery,
    this.onRemove,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showPhotoOptions(context),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildPhotoWidget(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () => _showPhotoOptions(context),
          icon: const Icon(Icons.photo_camera),
          label: Text(photoPath == null ? 'Add Photo' : 'Change Photo'),
        ),
      ],
    );
  }

  Widget _buildPhotoWidget() {
    if (photoPath != null && photoPath!.isNotEmpty) {
      final file = File(photoPath!);
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                padding: EdgeInsets.zero,
                onPressed: null, // Icon only, tap handled by GestureDetector
              ),
            ),
          ),
        ],
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(
        Icons.add_a_photo,
        size: 48,
        color: Colors.grey,
      ),
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                onCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                onGallery();
              },
            ),
            if (photoPath != null && onRemove != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo'),
                textColor: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  onRemove!();
                },
              ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
