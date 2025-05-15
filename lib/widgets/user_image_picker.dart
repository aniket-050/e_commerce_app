import 'dart:io';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/utils/file_upload_service.dart';
import 'package:get/get.dart';

class UserImagePicker extends StatelessWidget {
  final double size;
  final File? selectedImage;
  final String? imagePath;
  final Function(File file, String? path) onImageSelected;
  final bool isBusinessProfile;

  const UserImagePicker({
    super.key,
    this.size = 120.0,
    this.selectedImage,
    this.imagePath,
    required this.onImageSelected,
    this.isBusinessProfile = false,
  });

  Future<void> _pickImage(BuildContext context) async {
    final File? image = await FileUploadService.showImagePickerBottomSheet(
      context,
    );

    if (image != null) {
      // Show preview dialog
      final bool confirmed = await _showImagePreviewDialog(context, image);

      if (confirmed) {
        // Save the image to local storage only if confirmed
        final storedImagePath = await FileUploadService.saveFileToLocalStorage(
          image,
          customDir:
              isBusinessProfile
                  ? FileUploadService.USER_IMAGES_DIR
                  : 'user_profile_images',
        );

        onImageSelected(image, storedImagePath);
      }
    }
  }

  Future<bool> _showImagePreviewDialog(BuildContext context, File image) async {
    bool confirmed = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                color: AppTheme.primaryColor,
                width: double.infinity,
                child: Text(
                  isBusinessProfile
                      ? 'Business Logo Preview'
                      : 'Profile Picture Preview',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Image Preview
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child:
                    isBusinessProfile
                        ? SizedBox(
                          height: 200,
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(image, fit: BoxFit.cover),
                          ),
                        )
                        : SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: Image.file(image, fit: BoxFit.contain),
                        ),
              ),

              // Actions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        confirmed = false;
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        confirmed = true;
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      child: const Text('Use This Photo'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    return confirmed;
  }

  Widget _buildImageContent() {
    if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading selected image: $error");
          return _buildPlaceholder();
        },
      );
    } else if (imagePath != null) {
      if (imagePath!.startsWith('/')) {
        // Local file path
        return Image.file(
          File(imagePath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading local file image: $error");
            return _buildPlaceholder();
          },
        );
      } else if (imagePath!.startsWith('assets/')) {
        // Asset image
        return Image.asset(
          imagePath!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading asset image: $error");
            return _buildPlaceholder();
          },
        );
      } else if (imagePath!.startsWith('http')) {
        // Network image
        return Image.network(
          imagePath!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading network image: $error");
            return _buildPlaceholder();
          },
        );
      }
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        isBusinessProfile ? Icons.store : Icons.person,
        size: size * 0.4,
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildImageContent(),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isBusinessProfile ? 'Business Photo' : 'Profile Photo',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
