import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/services/file_service.dart';
import 'package:e_commerce_app/utils/app_theme.dart';

class ImagePickerWidget extends StatelessWidget {
  final double size;
  final String? imagePath;
  final Function(File) onImagePicked;
  final IconData placeholderIcon;
  final bool isCircular;
  final String label;

  const ImagePickerWidget({
    super.key,
    this.size = 150,
    this.imagePath,
    required this.onImagePicked,
    this.placeholderIcon = Icons.add_a_photo,
    this.isCircular = true,
    this.label = 'Add Photo',
  });

  @override
  Widget build(BuildContext context) {
    final FileService fileService = Get.find<FileService>();
    final BorderRadius borderRadius =
        isCircular
            ? BorderRadius.circular(size / 2)
            : BorderRadius.circular(12);

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final File? pickedImage = await fileService.showImagePickerDialog();
            if (pickedImage != null) {
              onImagePicked(pickedImage);
            }
          },
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: borderRadius,
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: _buildImageContent(),
            ),
          ),
        ),
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageContent() {
    // If we have a file path and it exists
    if (imagePath != null && imagePath!.isNotEmpty) {
      if (imagePath!.startsWith('http')) {
        // It's a network image
        return Image.network(
          imagePath!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildLoadingIndicator();
          },
          errorBuilder: (context, error, stackTrace) {
            print("Error loading network image: $error");
            return _buildPlaceholder();
          },
        );
      } else if (imagePath!.startsWith('assets/')) {
        // It's an asset image
        return Image.asset(
          imagePath!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading asset image: $error");
            return _buildPlaceholder();
          },
        );
      } else if (imagePath!.startsWith('/')) {
        // It's a local file path
        final file = File(imagePath!);
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading file image: $error");
            return _buildPlaceholder();
          },
        );
      } else {
        // Unexpected format
        print("Unknown image path format: $imagePath");
        return _buildPlaceholder();
      }
    }

    // Default placeholder
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            placeholderIcon,
            size: size / 3,
            color: AppTheme.primaryColor.withOpacity(0.7),
          ),
          if (!isCircular && label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Tap to select',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryColor.withOpacity(0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        width: size / 3,
        height: size / 3,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      ),
    );
  }
}
