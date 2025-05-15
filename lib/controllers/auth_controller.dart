import 'package:get/get.dart';
import 'package:e_commerce_app/models/user_model.dart';
import 'package:e_commerce_app/utils/dummy_data.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:uuid/uuid.dart';
import 'package:e_commerce_app/services/shared_prefs_service.dart';
import 'package:e_commerce_app/utils/service_initializer.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final Rx<User?> _currentUser = Rx<User?>(null);
  late SharedPrefsService _prefsService;

  User? get currentUser => _currentUser.value;

  bool get isLoggedIn => _currentUser.value != null;

  bool get isBuyer => _currentUser.value?.role == 'buyer';

  bool get isSeller => _currentUser.value?.role == 'seller';

  bool get isAdmin => _currentUser.value?.role == 'admin';

  @override
  void onInit() async {
    super.onInit();
    _prefsService = await Get.putAsync(() => SharedPrefsService().init());

    // Check if user is already logged in
    final isLoggedIn = _prefsService.isLoggedIn();
    if (isLoggedIn) {
      final savedUser = _prefsService.getUser();
      if (savedUser != null) {
        _currentUser.value = savedUser;

        // Register buyer-specific services if user is a buyer
        if (savedUser.role == 'buyer') {
          await ServiceInitializer.registerBuyerServices(savedUser.id);
        }
      }
    }
  }

  // Method to login
  Future<bool> login(String username, String password) async {
    try {
      print("Attempting login with username/email: $username");

      final user = DummyData.getUserByCredentials(username, password);

      if (user != null) {
        print("User found: ${user.username}, Role: ${user.role}");
        _currentUser.value = user;

        // Save user data to shared preferences
        await _prefsService.saveUser(user);
        await _prefsService.setLoggedIn(true);
        await _prefsService.saveUserRole(user.role);

        // Register buyer-specific services if user is a buyer
        if (user.role == 'buyer') {
          await ServiceInitializer.registerBuyerServices(user.id);
        }

        // Navigate to appropriate dashboard based on role
        if (user.role == 'buyer') {
          Get.offAllNamed(AppRoutes.buyerHome);
        } else if (user.role == 'seller') {
          print("Navigating seller to dashboard: ${user.username}");
          Get.offAllNamed(AppRoutes.sellerDashboard);
        } else if (user.role == 'admin') {
          Get.offAllNamed(AppRoutes.adminDashboard);
        }

        return true;
      } else {
        print("No user found with these credentials");
        // Check if a user with this username exists but password is wrong
        final userExists = DummyData.users.any(
          (u) => u.username == username || u.email == username,
        );

        if (userExists) {
          print("User exists but password is incorrect");
          Get.snackbar(
            'Login Failed',
            'Incorrect password, please try again',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[800],
            duration: const Duration(seconds: 3),
          );
        } else {
          print("Username/email not found");
          Get.snackbar(
            'Login Failed',
            'Username or email not found',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[800],
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      print("Exception during login: $e");
      Get.snackbar(
        'Error',
        'An error occurred during login: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        duration: const Duration(seconds: 3),
      );
    }

    return false;
  }

  // Method to logout
  Future<void> logout() async {
    // Unregister buyer-specific services if user is a buyer
    if (isBuyer) {
      ServiceInitializer.unregisterBuyerServices();
    }

    // Clear shared preferences
    await _prefsService.clearUserData();

    _currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

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
      profileImageUrl: null,
    );

    // Add user to dummy data
    DummyData.addUser(newUser);

    // Auto login after registration
    await _prefsService.saveUser(newUser);
    await _prefsService.setLoggedIn(true);
    await _prefsService.saveUserRole(newUser.role);
    _currentUser.value = newUser;

    // Register buyer-specific services for the new buyer
    await ServiceInitializer.registerBuyerServices(newUser.id);

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
      profileImageUrl: null,
    );

    // Add user to dummy data
    DummyData.addUser(newUser);

    // Auto login after registration
    await _prefsService.saveUser(newUser);
    await _prefsService.setLoggedIn(true);
    await _prefsService.saveUserRole(newUser.role);
    _currentUser.value = newUser;

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
      profileImageUrl: null,
    );

    _currentUser.value = newUser;

    // Save partial registration data temporarily
    await _prefsService.saveUser(newUser);

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
        profileImageUrl: profileImageUrl,
        businessName: businessName,
        businessAddress: businessAddress,
        businessCategory: businessCategory,
        businessDescription: businessDescription,
      );

      // Add completed seller user to dummy data
      DummyData.addUser(updatedUser);
      _currentUser.value = updatedUser;

      // Update stored user data and complete login
      await _prefsService.saveUser(updatedUser);
      await _prefsService.setLoggedIn(true);
      await _prefsService.saveUserRole(updatedUser.role);

      Get.offAllNamed(AppRoutes.sellerDashboard);
      return true;
    }

    return false;
  }

  // Method to update user profile
  Future<bool> updateUserProfile(User updatedUser) async {
    try {
      // In a real app, this would call an API to update the user
      // Find and update the user in the dummy data
      final userIndex = DummyData.users.indexWhere(
        (user) => user.id == updatedUser.id,
      );

      if (userIndex >= 0) {
        // Create a new user with the password from the existing user
        final password = DummyData.users[userIndex].password;
        final newUserWithPassword = User(
          id: updatedUser.id,
          username: updatedUser.username,
          email: updatedUser.email,
          password: password, // Include the password from the existing user
          role: updatedUser.role,
          phone: updatedUser.phone,
          profileImageUrl: updatedUser.profileImageUrl,
          businessName: updatedUser.businessName,
          businessAddress: updatedUser.businessAddress,
          businessCategory: updatedUser.businessCategory,
          businessDescription: updatedUser.businessDescription,
        );

        DummyData.users[userIndex] = newUserWithPassword;
        _currentUser.value = newUserWithPassword;

        // Update stored user data
        await _prefsService.saveUser(newUserWithPassword);

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Save user settings
  Future<bool> saveUserSettings(Map<String, dynamic> settings) async {
    return await _prefsService.saveUserSettings(settings);
  }

  // Get user settings
  Map<String, dynamic>? getUserSettings() {
    return _prefsService.getUserSettings();
  }

  // Save notification settings
  Future<bool> saveNotificationSettings(Map<String, dynamic> settings) async {
    return await _prefsService.saveNotificationSettings(settings);
  }

  // Get notification settings
  Map<String, dynamic> getNotificationSettings() {
    return _prefsService.getNotificationSettings();
  }

  // Save app language
  Future<bool> saveAppLanguage(String languageCode) async {
    return await _prefsService.saveAppLanguage(languageCode);
  }

  // Get app language
  String getAppLanguage() {
    return _prefsService.getAppLanguage();
  }
}
