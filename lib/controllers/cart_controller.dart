import 'package:get/get.dart';
import 'package:e_commerce_app/models/cart_model.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:e_commerce_app/services/local_storage_service.dart';

class CartController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  late LocalStorageService _storageService;

  final Rx<Cart?> _cart = Rx<Cart?>(null);

  Cart? get cart => _cart.value;

  int get itemCount => _cart.value?.itemCount ?? 0;

  double get totalAmount => _cart.value?.totalAmount ?? 0;

  List<CartItem> get items => _cart.value?.itemsList ?? [];

  @override
  void onInit() {
    super.onInit();
    _initCart();
  }

  Future<void> _initCart() async {
    if (_authController.isBuyer && _authController.currentUser != null) {
      final userId = _authController.currentUser!.id;
      _storageService = Get.put(
        LocalStorageService(userId),
        tag: 'cart_storage',
      );
      await _storageService.init();

      // Load cart from local storage
      _cart.value = _storageService.getCart();
      update();
    } else {
      // Initialize with an empty cart for non-buyer users
      _cart.value = Cart(buyerId: 'guest');
      update();
    }
  }

  void addToCart(Product product) async {
    if (!_authController.isBuyer) {
      Get.snackbar(
        'Error',
        'Only buyers can add items to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_cart.value == null) {
      await _initCart();
    }

    _cart.value?.addItem(product);
    await _saveCartToStorage();
    update(); // Notify listeners

    Get.snackbar(
      'Success',
      '${product.name} added to cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeFromCart(String productId) {
    _cart.value?.removeItem(productId);
    _saveCartToStorage();
    update(); // Notify listeners
  }

  void increaseQuantity(String productId) {
    final product = _cart.value?.items[productId]?.product;
    if (product != null) {
      _cart.value?.addItem(product);
      _saveCartToStorage();
      update(); // Notify listeners
    }
  }

  void decreaseQuantity(String productId) {
    _cart.value?.decreaseQuantity(productId);
    _saveCartToStorage();
    update(); // Notify listeners
  }

  void clearCart() {
    _cart.value?.clear();
    _saveCartToStorage();
    update(); // Notify listeners
  }

  // Save cart to local storage
  Future<void> _saveCartToStorage() async {
    if (_cart.value != null) {
      await _storageService.saveCart(_cart.value!);
    }
  }

  void proceedToCheckout() {
    if (itemCount == 0) {
      Get.snackbar(
        'Error',
        'Your cart is empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.toNamed(AppRoutes.checkout);
  }

  Future<bool> placeOrder() async {
    if (itemCount == 0 || !_authController.isBuyer) {
      return false;
    }

    // In a real app, this would actually create an order in the database
    // For demo purposes, we'll just clear the cart and show success

    clearCart();

    Get.offAllNamed(AppRoutes.orderSuccess);
    return true;
  }
}
