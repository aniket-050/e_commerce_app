import 'package:get/get.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/models/wishlist_model.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/services/local_storage_service.dart';

class WishlistController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  late LocalStorageService _storageService;

  final Rx<Wishlist?> _wishlist = Rx<Wishlist?>(null);

  Wishlist? get wishlist => _wishlist.value;

  int get itemCount => _wishlist.value?.count ?? 0;

  List<Product> get products => _wishlist.value?.products ?? [];

  @override
  void onInit() {
    super.onInit();
    _initWishlist();
  }

  Future<void> _initWishlist() async {
    if (_authController.isBuyer && _authController.currentUser != null) {
      final userId = _authController.currentUser!.id;
      _storageService = Get.put(
        LocalStorageService(userId),
        tag: 'wishlist_storage',
      );
      await _storageService.init();

      // Load wishlist from local storage
      final products = _storageService.getWishlist();
      _wishlist.value = Wishlist(userId: userId, products: products);
      update();
    } else {
      _wishlist.value = null;
      update();
    }
  }

  bool isInWishlist(String productId) {
    return _wishlist.value?.isProductInWishlist(productId) ?? false;
  }

  void addToWishlist(Product product) {
    if (!_authController.isBuyer) {
      Get.snackbar(
        'Error',
        'Only buyers can add items to wishlist',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_wishlist.value == null) {
      _initWishlist();
    }

    _wishlist.value?.addProduct(product);
    _saveWishlistToStorage();
    update();

    Get.snackbar(
      'Success',
      '${product.name} added to wishlist',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeFromWishlist(String productId) {
    _wishlist.value?.removeProduct(productId);
    _saveWishlistToStorage();
    update();

    Get.snackbar(
      'Success',
      'Item removed from wishlist',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      removeFromWishlist(product.id);
    } else {
      addToWishlist(product);
    }
  }

  void clearWishlist() {
    _wishlist.value?.clear();
    _saveWishlistToStorage();
    update();
  }

  // Save wishlist to local storage
  Future<void> _saveWishlistToStorage() async {
    if (_wishlist.value != null) {
      await _storageService.saveWishlist(_wishlist.value!.products);
    }
  }
}
