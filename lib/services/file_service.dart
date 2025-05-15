import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';

class FileService extends GetxService {
  final ImagePicker _imagePicker = ImagePicker();

  // Observable variables to track selected files
  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<File?> selectedVideo = Rx<File?>(null);
  final RxList<File> selectedFiles = <File>[].obs;

  // Method to pick image from camera or gallery
  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80, // Reduce image quality to save storage
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        selectedImage.value = imageFile;
        return imageFile;
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  // Method to pick video from camera or gallery
  Future<File?> pickVideo({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 2), // Limit video length
      );

      if (pickedFile != null) {
        final File videoFile = File(pickedFile.path);
        selectedVideo.value = videoFile;
        return videoFile;
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick video: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  // Method to pick files (documents, etc.)
  Future<List<File>?> pickFiles({
    List<String>? allowedExtensions,
    FileType type = FileType.any,
  }) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null) {
        final List<File> files =
            result.paths.map((path) => File(path!)).toList();
        selectedFiles.value = files;
        return files;
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick files: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  // Method to save picked file to app directory (for persistence)
  Future<File?> saveFileToAppDirectory(File file) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = path.basename(file.path);
      final String savedPath = path.join(appDir.path, fileName);
      final File savedFile = await file.copy(savedPath);
      return savedFile;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save file: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  // Show picker dialog with camera and gallery options
  Future<File?> showImagePickerDialog() async {
    File? pickedImage;

    await Get.dialog(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Get.back();
                pickedImage = await pickImage(source: ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Get.back();
                pickedImage = await pickImage(source: ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );

    return pickedImage;
  }

  // Show picker dialog with camera and gallery options for video
  Future<File?> showVideoPickerDialog() async {
    File? pickedVideo;

    await Get.dialog(
      AlertDialog(
        title: const Text('Select Video Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Record Video'),
              onTap: () async {
                Get.back();
                pickedVideo = await pickVideo(source: ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Get.back();
                pickedVideo = await pickVideo(source: ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );

    return pickedVideo;
  }

  // Utility method to get a file's size in readable format
  String getFileSize(File file) {
    final int bytes = file.lengthSync();
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  // Clear all selected files
  void clearSelections() {
    selectedImage.value = null;
    selectedVideo.value = null;
    selectedFiles.clear();
  }
}
