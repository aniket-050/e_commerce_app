import 'package:e_commerce_app/models/user_model.dart';
import 'package:e_commerce_app/utils/dummy_data.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/routes/app_routes.dart';

class AuthController extends GetxController {
  final _currentUser = Rx<User?>(null);
  // Method to register a new buyer
  Future<bool> registerBuyer({
    required String username,
    required String email,
    required String password,
    String? phone,
  }) async {
    // Check if a user with the same username or email already exists
    final existingUser = DummyData.getUserByUsernameOrEmail(username, email);
    if (existingUser != null) {
      return false;
    }

    // Create new buyer user with UUID
    final newUser = User(
      id: const Uuid().v4(),
      username: username,
      email: email,
      password: password,
      role: 'buyer',
      phone: phone,
      profileImageUrl: null, // Use default icon instead of image
    );

    // Add user to dummy data
    DummyData.addUser(newUser);
    return true;
  }

  // Method to register a new admin
  Future<bool> registerAdmin({
    required String username,
    required String email,
    required String password,
    required String adminCode,
  }) async {
    // Simple validation for admin code (in a real app, this would be more secure)
    if (adminCode != 'admin123') {
      return false;
    }

    // Check if a user with the same username or email already exists
    final existingUser = DummyData.getUserByUsernameOrEmail(username, email);
    if (existingUser != null) {
      return false;
    }

    // Create new admin user with UUID
    final newUser = User(
      id: const Uuid().v4(),
      username: username,
      email: email,
      password: password,
      role: 'admin',
      profileImageUrl: null, // Use default icon instead of image
    );

    // Add user to dummy data
    DummyData.addUser(newUser);
    return true;
  }

  // Method to register a new seller
  Future<bool> registerSeller({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    // Check if a user with the same username or email already exists
    final existingUser = DummyData.getUserByUsernameOrEmail(username, email);
    if (existingUser != null) {
      return false;
    }

    // Create temporary seller user (will be completed in the next step)
    final newUser = User(
      id: const Uuid().v4(),
      username: username,
      email: email,
      password: password,
      role: 'seller',
      phone: phone,
      profileImageUrl: null, // Use default icon instead of image
    );

    _currentUser.value = newUser;
    Get.toNamed(AppRoutes.sellerProfileCompletion);
    return true;
  }

  // Method to complete seller profile
  Future<bool> completeSellerProfile({
    required String businessName,
    required String businessAddress,
    required String businessCategory,
    required String businessDescription,
    String? profileImageUrl,
  }) async {
    if (_currentUser.value != null) {
      final updatedUser = User(
        id: _currentUser.value!.id,
        username: _currentUser.value!.username,
        email: _currentUser.value!.email,
        password: _currentUser.value!.password,
        role: _currentUser.value!.role,
        phone: _currentUser.value!.phone,
        profileImageUrl: null, // Use default icon instead of image
        businessName: businessName,
        businessAddress: businessAddress,
        businessCategory: businessCategory,
        businessDescription: businessDescription,
      );

      // Add completed seller user to dummy data
      DummyData.addUser(updatedUser);
      _currentUser.value = updatedUser;
      Get.offAllNamed(AppRoutes.sellerDashboard);
      return true;
    }

    return false;
  }
}
