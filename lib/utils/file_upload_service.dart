import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:e_commerce_app/utils/app_theme.dart';

class FileUploadService {
  static final ImagePicker _picker = ImagePicker();
  static const String PRODUCT_IMAGES_DIR = 'product_images';
  static const String USER_IMAGES_DIR = 'user_images';

  // Pick an image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      print("Opening gallery picker");
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        print("Image picked from gallery: ${pickedFile.path}");
        final File imageFile = File(pickedFile.path);

        // Verify the file exists
        if (await imageFile.exists()) {
          // Crop the image
          final File? croppedFile = await _cropImage(imageFile);
          if (croppedFile != null && await croppedFile.exists()) {
            print("Cropped image path: ${croppedFile.path}");
            return croppedFile;
          } else {
            print(
              "Using original image as cropped image is null or doesn't exist",
            );
            return imageFile;
          }
        } else {
          print("Original image file doesn't exist");
          return null;
        }
      }
      print("No image selected from gallery");
      return null;
    } catch (e) {
      print("Error picking image from gallery: $e");
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return null;
    }
  }

  // Take a photo using camera
  static Future<File?> pickImageFromCamera() async {
    try {
      print("Opening camera picker");
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        print("Image captured from camera: ${pickedFile.path}");
        final File imageFile = File(pickedFile.path);

        // Verify the file exists
        if (await imageFile.exists()) {
          // Crop the image
          final File? croppedFile = await _cropImage(imageFile);
          if (croppedFile != null && await croppedFile.exists()) {
            print("Cropped image path: ${croppedFile.path}");
            return croppedFile;
          } else {
            print(
              "Using original image as cropped image is null or doesn't exist",
            );
            return imageFile;
          }
        } else {
          print("Original image file doesn't exist");
          return null;
        }
      }
      print("No image captured from camera");
      return null;
    } catch (e) {
      print("Error capturing image from camera: $e");
      Get.snackbar(
        'Error',
        'Failed to take photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return null;
    }
  }

  // Crop the selected image
  static Future<File?> _cropImage(File imageFile) async {
    try {
      print("Starting image cropping: ${imageFile.path}");

      // First check if the file exists
      if (!await imageFile.exists()) {
        print("Image file doesn't exist for cropping: ${imageFile.path}");
        return null;
      }

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        maxWidth: 800,
        maxHeight: 800,
        compressQuality: 90,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppTheme.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioPickerButtonHidden: false,
            cancelButtonTitle: 'Cancel',
            doneButtonTitle: 'Done',
          ),
        ],
      );

      if (croppedFile != null) {
        File file = File(croppedFile.path);
        if (await file.exists()) {
          print("Image cropped successfully: ${file.path}");
          return file;
        } else {
          print("Cropped file path doesn't exist: ${croppedFile.path}");
          return null;
        }
      }

      print("User cancelled cropping, returning original image");
      return imageFile; // Return original if user cancels
    } catch (e) {
      print('Error cropping image: $e');
      // Return original image if cropping fails
      return imageFile;
    }
  }

  // Save a file to local storage and return the path
  static Future<String?> saveFileToLocalStorage(
    File file, {
    String? customDir,
  }) async {
    try {
      print("saveFileToLocalStorage: Saving file: ${file.path}");

      // First check if file exists
      if (!await file.exists()) {
        print(
          "saveFileToLocalStorage: Error - File does not exist at: ${file.path}",
        );
        return null;
      }

      final Directory appDir = await getApplicationDocumentsDirectory();

      // Create directory if it doesn't exist
      final String dirName = customDir ?? PRODUCT_IMAGES_DIR;
      final Directory directory = Directory('${appDir.path}/$dirName');
      if (!await directory.exists()) {
        print("saveFileToLocalStorage: Creating directory: ${directory.path}");
        await directory.create(recursive: true);
      }

      // Create a unique filename with original extension
      final String fileExtension = path.extension(file.path);
      final String uniqueFileName = '${const Uuid().v4()}$fileExtension';
      final String savedPath = '${directory.path}/$uniqueFileName';

      print("saveFileToLocalStorage: Copying file to: $savedPath");

      // Copy file to new location
      final File newFile = await file.copy(savedPath);

      // Verify the file was copied successfully
      if (await newFile.exists()) {
        print("saveFileToLocalStorage: File saved successfully at: $savedPath");
        // Return the complete file path
        return savedPath;
      } else {
        print(
          "saveFileToLocalStorage: Failed to verify saved file at: $savedPath",
        );
        return null;
      }
    } catch (e) {
      print('saveFileToLocalStorage: Error saving file: $e');
      return null;
    }
  }

  // Get a file from local storage
  static Future<File?> getFileFromLocalStorage(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      print('Error getting file: $e');
      return null;
    }
  }

  // Delete a file from local storage
  static Future<bool> deleteFileFromLocalStorage(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  // Show improved image picker bottom sheet
  static Future<File?> showImagePickerBottomSheet(BuildContext context) async {
    print("Opening image picker bottom sheet");
    File? result;

    // Use a Completer to handle the asynchronous result
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      'Select Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, 'gallery');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.photo_library,
                                color: AppTheme.primaryColor,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Gallery',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, 'camera');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: AppTheme.primaryColor,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Camera',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
    ).then((source) async {
      if (source == 'gallery') {
        print("Gallery selected");
        result = await pickImageFromGallery();
      } else if (source == 'camera') {
        print("Camera selected");
        result = await pickImageFromCamera();
      }
    });

    print("Final image result: $result");
    return result;
  }

  // Upload file to server (mock implementation)
  static Future<String?> uploadFileToServer(File file) async {
    // This would be an actual API call in a real app
    // For demo purposes, we'll just simulate a delay and return a fake URL

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, you'd upload the file to your server/cloud storage
      // and get back a URL to the uploaded file
      final String fileName = path.basename(file.path);
      final String fakeUrl = 'https://example.com/uploads/$fileName';

      return fakeUrl;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload file: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return null;
    }
  }
}
