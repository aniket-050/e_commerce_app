import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/models/user_model.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/widgets/custom_button.dart';
import 'package:e_commerce_app/widgets/user_image_picker.dart';
import 'package:e_commerce_app/utils/file_upload_service.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _businessNameController;
  late TextEditingController _businessCategoryController;
  late TextEditingController _businessDescriptionController;
  late TextEditingController _businessAddressController;
  bool _isEditing = false;
  bool _isLoading = false;

  // Image selection
  File? _selectedImage;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    final user = _authController.currentUser!;
    _businessNameController = TextEditingController(
      text: user.businessName ?? '',
    );
    _businessCategoryController = TextEditingController(
      text: user.businessCategory ?? '',
    );
    _businessDescriptionController = TextEditingController(
      text: user.businessDescription ?? '',
    );
    _businessAddressController = TextEditingController(
      text: user.businessAddress ?? '',
    );
    _profileImagePath = user.profileImageUrl;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessCategoryController.dispose();
    _businessDescriptionController.dispose();
    _businessAddressController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _handleImageSelected(File image, String? path) {
    setState(() {
      _selectedImage = image;
      _profileImagePath = path;
    });
  }

  Future<void> _saveBusinessProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _authController.currentUser!;
      // Note: In a real application, this would be handled securely
      // We're passing the password from the existing user object for the mock implementation
      final updatedUser = User(
        id: user.id,
        username: user.username,
        email: user.email,
        password:
            '', // This will be replaced in the controller with actual password
        role: user.role,
        phone: user.phone,
        profileImageUrl: _profileImagePath,
        businessName: _businessNameController.text.trim(),
        businessCategory: _businessCategoryController.text.trim(),
        businessDescription: _businessDescriptionController.text.trim(),
        businessAddress: _businessAddressController.text.trim(),
      );

      // In a real app, this would call an API to update the user profile
      await _authController.updateUserProfile(updatedUser);
      Get.snackbar(
        'Success',
        'Business profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update business profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authController.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not found. Please login again.')),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Business Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image Section
              Center(
                child: Column(
                  children: [
                    UserImagePicker(
                      selectedImage: _selectedImage,
                      imagePath: _profileImagePath,
                      onImageSelected: _handleImageSelected,
                      isBusinessProfile: true,
                      size: 100,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(user.email, style: TextStyle(color: Colors.grey[600])),
                    if (user.phone != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.phone!,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Business Details Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Business Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(
                      _isEditing ? Icons.close : Icons.edit,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: _toggleEdit,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Business Name
              _buildTextField(
                label: 'Business Name',
                controller: _businessNameController,
                enabled: _isEditing,
                validator: (value) {
                  if (_isEditing && (value == null || value.isEmpty)) {
                    return 'Please enter your business name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Business Category
              _buildTextField(
                label: 'Business Category',
                controller: _businessCategoryController,
                enabled: _isEditing,
                validator: (value) {
                  if (_isEditing && (value == null || value.isEmpty)) {
                    return 'Please enter your business category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Business Description
              _buildTextField(
                label: 'Business Description',
                controller: _businessDescriptionController,
                enabled: _isEditing,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Business Address
              _buildTextField(
                label: 'Business Address',
                controller: _businessAddressController,
                enabled: _isEditing,
                maxLines: 2,
              ),
              const SizedBox(height: 32),

              // Save Button
              if (_isEditing)
                CustomButton(
                  label: 'Save Changes',
                  onPressed: _isLoading ? null : _saveBusinessProfile,
                  isLoading: _isLoading,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
