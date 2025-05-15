import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/models/user_model.dart';

class SharedPrefsService extends GetxService {
  static const String USER_KEY = 'user_data';
  static const String IS_LOGGED_IN = 'is_logged_in';
  static const String AUTH_TOKEN = 'auth_token';
  static const String REFRESH_TOKEN = 'refresh_token';
  static const String USER_SETTINGS = 'user_settings';
  static const String APP_LANGUAGE = 'app_language';
  static const String NOTIFICATION_SETTINGS = 'notification_settings';
  static const String USER_ROLE = 'user_role';

  late SharedPreferences _prefs;

  Future<SharedPrefsService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // User Data Methods
  Future<bool> saveUser(User user) async {
    final userData = jsonEncode(user.toJson());
    return await _prefs.setString(USER_KEY, userData);
  }

  User? getUser() {
    final userData = _prefs.getString(USER_KEY);
    if (userData == null) return null;

    try {
      return User.fromJson(jsonDecode(userData));
    } catch (e) {
      print('Error parsing user data: $e');
      return null;
    }
  }

  // Authentication Methods
  Future<bool> setLoggedIn(bool value) async {
    return await _prefs.setBool(IS_LOGGED_IN, value);
  }

  bool isLoggedIn() {
    return _prefs.getBool(IS_LOGGED_IN) ?? false;
  }

  Future<bool> saveAuthToken(String token) async {
    return await _prefs.setString(AUTH_TOKEN, token);
  }

  String? getAuthToken() {
    return _prefs.getString(AUTH_TOKEN);
  }

  Future<bool> saveRefreshToken(String token) async {
    return await _prefs.setString(REFRESH_TOKEN, token);
  }

  String? getRefreshToken() {
    return _prefs.getString(REFRESH_TOKEN);
  }

  Future<bool> saveUserRole(String role) async {
    return await _prefs.setString(USER_ROLE, role);
  }

  String? getUserRole() {
    return _prefs.getString(USER_ROLE);
  }

  // User Settings Methods
  Future<bool> saveUserSettings(Map<String, dynamic> settings) async {
    return await _prefs.setString(USER_SETTINGS, jsonEncode(settings));
  }

  Map<String, dynamic>? getUserSettings() {
    final settingsStr = _prefs.getString(USER_SETTINGS);
    if (settingsStr == null) return null;

    try {
      return jsonDecode(settingsStr) as Map<String, dynamic>;
    } catch (e) {
      print('Error parsing user settings: $e');
      return null;
    }
  }

  // App Language
  Future<bool> saveAppLanguage(String languageCode) async {
    return await _prefs.setString(APP_LANGUAGE, languageCode);
  }

  String getAppLanguage() {
    return _prefs.getString(APP_LANGUAGE) ?? 'en'; // Default to English
  }

  // Notification Settings
  Future<bool> saveNotificationSettings(Map<String, dynamic> settings) async {
    return await _prefs.setString(NOTIFICATION_SETTINGS, jsonEncode(settings));
  }

  Map<String, dynamic> getNotificationSettings() {
    final settingsStr = _prefs.getString(NOTIFICATION_SETTINGS);
    if (settingsStr == null) {
      // Default notification settings
      return {
        'push_enabled': true,
        'email_enabled': true,
        'order_updates': true,
        'promotions': true,
      };
    }

    try {
      return jsonDecode(settingsStr) as Map<String, dynamic>;
    } catch (e) {
      print('Error parsing notification settings: $e');
      return {
        'push_enabled': true,
        'email_enabled': true,
        'order_updates': true,
        'promotions': true,
      };
    }
  }

  // Clear user data on logout
  Future<bool> clearUserData() async {
    await _prefs.remove(USER_KEY);
    await _prefs.remove(IS_LOGGED_IN);
    await _prefs.remove(AUTH_TOKEN);
    await _prefs.remove(REFRESH_TOKEN);
    await _prefs.remove(USER_ROLE);
    return true;
  }

  // Clear all preferences
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
