import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/routes/app_pages.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/controllers/product_controller.dart';
import 'package:e_commerce_app/controllers/cart_controller.dart';
import 'package:e_commerce_app/controllers/order_controller.dart';
import 'package:e_commerce_app/controllers/user_controller.dart';
import 'package:e_commerce_app/controllers/wishlist_controller.dart';
import 'package:e_commerce_app/services/shared_prefs_service.dart';
import 'package:e_commerce_app/utils/service_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await ServiceInitializer.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ShopEase',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Register controllers that aren't already registered
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
    Get.put(ProductController());
    Get.put(OrderController());
    Get.put(UserController());

    // Always register cart and wishlist controllers to avoid "not found" errors
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController());
    }
    if (!Get.isRegistered<WishlistController>()) {
      Get.put(WishlistController());
    }
  }
}
