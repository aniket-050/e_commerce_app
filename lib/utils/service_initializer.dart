import 'package:get/get.dart';
import 'package:e_commerce_app/services/shared_prefs_service.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/controllers/cart_controller.dart';
import 'package:e_commerce_app/controllers/wishlist_controller.dart';
import 'package:e_commerce_app/services/file_service.dart';

class ServiceInitializer {
  static Future<void> init() async {
    // Initialize shared preferences service
    final prefsService = await Get.putAsync(() => SharedPrefsService().init());

    // Register the FileService
    Get.put(FileService(), permanent: true);

    // Register controllers
    Get.lazyPut(() => AuthController(), fenix: true);

    // Register cart and wishlist controllers after auth is initialized
    final authController = Get.find<AuthController>();

    // Only register cart and wishlist if user is a buyer
    if (authController.isBuyer && authController.currentUser != null) {
      final userId = authController.currentUser!.id;

      Get.lazyPut(() => CartController(), fenix: true);
      Get.lazyPut(() => WishlistController(), fenix: true);
    }
  }

  // Helper method to register buyer-specific controllers when a buyer logs in
  static Future<void> registerBuyerServices(String userId) async {
    // Register cart and wishlist controllers if not already registered
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut(() => CartController(), fenix: true);
    }

    if (!Get.isRegistered<WishlistController>()) {
      Get.lazyPut(() => WishlistController(), fenix: true);
    }
  }

  // Helper method to unregister buyer-specific controllers on logout
  static void unregisterBuyerServices() {
    if (Get.isRegistered<CartController>()) {
      Get.delete<CartController>();
    }

    if (Get.isRegistered<WishlistController>()) {
      Get.delete<WishlistController>();
    }
  }
}
