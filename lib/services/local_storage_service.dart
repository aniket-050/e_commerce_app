import 'dart:convert';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/models/cart_model.dart';

class LocalStorageService extends GetxService {
  static const String CART_KEY = 'user_cart';
  static const String WISHLIST_KEY = 'user_wishlist';
  static const String RECENT_PRODUCTS_KEY = 'recent_products';
  static const String SEARCHED_PRODUCTS_KEY = 'searched_products';
  static const String BROWSING_HISTORY_KEY = 'browsing_history';

  late LocalStorage _storage;
  final String _userId;

  // Constructor takes user ID to separate storage for different users
  LocalStorageService(this._userId) {
    _storage = LocalStorage('e_commerce_app_${_userId}.json');
  }

  Future<LocalStorageService> init() async {
    await _storage.ready;
    return this;
  }

  // Generate key with user ID to keep data separate
  String _getUserSpecificKey(String baseKey) {
    return '${baseKey}_$_userId';
  }

  // Cart Methods
  Future<bool> saveCart(Cart cart) async {
    try {
      final cartItems = cart.items.values.map((item) => item.toJson()).toList();
      await _storage.setItem(
        _getUserSpecificKey(CART_KEY),
        jsonEncode(cartItems),
      );
      return true;
    } catch (e) {
      print('Error saving cart: $e');
      return false;
    }
  }

  Cart getCart() {
    try {
      final cartData = _storage.getItem(_getUserSpecificKey(CART_KEY));
      if (cartData == null) {
        return Cart(buyerId: _userId);
      }

      final cartItemsList = jsonDecode(cartData) as List;
      final Map<String, CartItem> items = {};

      for (var item in cartItemsList) {
        final cartItem = CartItem.fromJson(item);
        items[cartItem.product.id] = cartItem;
      }

      return Cart(buyerId: _userId, items: items);
    } catch (e) {
      print('Error retrieving cart: $e');
      return Cart(buyerId: _userId);
    }
  }

  // Wishlist Methods
  Future<bool> saveWishlist(List<Product> products) async {
    try {
      final productsJson = products.map((product) => product.toJson()).toList();
      await _storage.setItem(
        _getUserSpecificKey(WISHLIST_KEY),
        jsonEncode(productsJson),
      );
      return true;
    } catch (e) {
      print('Error saving wishlist: $e');
      return false;
    }
  }

  List<Product> getWishlist() {
    try {
      final wishlistData = _storage.getItem(_getUserSpecificKey(WISHLIST_KEY));
      if (wishlistData == null) {
        return [];
      }

      final productsList = jsonDecode(wishlistData) as List;
      return productsList.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      print('Error retrieving wishlist: $e');
      return [];
    }
  }

  Future<bool> addToWishlist(Product product) async {
    final wishlist = getWishlist();

    // Check if product already exists in wishlist
    if (!wishlist.any((p) => p.id == product.id)) {
      wishlist.add(product);
      return await saveWishlist(wishlist);
    }
    return true;
  }

  Future<bool> removeFromWishlist(String productId) async {
    final wishlist = getWishlist();
    wishlist.removeWhere((product) => product.id == productId);
    return await saveWishlist(wishlist);
  }

  bool isInWishlist(String productId) {
    final wishlist = getWishlist();
    return wishlist.any((product) => product.id == productId);
  }

  // Recent Products Methods
  Future<bool> addToRecentProducts(Product product) async {
    try {
      final recentProducts = getRecentProducts();

      // Remove if already exists (to move it to the top)
      recentProducts.removeWhere((p) => p.id == product.id);

      // Add to the beginning of the list
      recentProducts.insert(0, product);

      // Limit to 20 recent products
      final limitedList = recentProducts.take(20).toList();

      final productsJson = limitedList.map((p) => p.toJson()).toList();
      await _storage.setItem(
        _getUserSpecificKey(RECENT_PRODUCTS_KEY),
        jsonEncode(productsJson),
      );
      return true;
    } catch (e) {
      print('Error adding to recent products: $e');
      return false;
    }
  }

  List<Product> getRecentProducts() {
    try {
      final data = _storage.getItem(_getUserSpecificKey(RECENT_PRODUCTS_KEY));
      if (data == null) {
        return [];
      }

      final productsList = jsonDecode(data) as List;
      return productsList.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      print('Error retrieving recent products: $e');
      return [];
    }
  }

  // Browsing History Methods
  Future<bool> addToBrowsingHistory(
    String productId,
    DateTime timestamp,
  ) async {
    try {
      final history = getBrowsingHistory();

      // Remove if already exists
      history.removeWhere((entry) => entry['productId'] == productId);

      // Add to the beginning
      history.insert(0, {
        'productId': productId,
        'timestamp': timestamp.toIso8601String(),
      });

      // Limit to 100 entries
      final limitedHistory = history.take(100).toList();

      await _storage.setItem(
        _getUserSpecificKey(BROWSING_HISTORY_KEY),
        jsonEncode(limitedHistory),
      );
      return true;
    } catch (e) {
      print('Error adding to browsing history: $e');
      return false;
    }
  }

  List<Map<String, dynamic>> getBrowsingHistory() {
    try {
      final data = _storage.getItem(_getUserSpecificKey(BROWSING_HISTORY_KEY));
      if (data == null) {
        return [];
      }

      final historyList = jsonDecode(data) as List;
      return historyList.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error retrieving browsing history: $e');
      return [];
    }
  }

  // Clear methods
  Future<bool> clearCart() async {
    try {
      await _storage.deleteItem(_getUserSpecificKey(CART_KEY));
      return true;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  Future<bool> clearWishlist() async {
    try {
      await _storage.deleteItem(_getUserSpecificKey(WISHLIST_KEY));
      return true;
    } catch (e) {
      print('Error clearing wishlist: $e');
      return false;
    }
  }

  Future<bool> clearAllUserData() async {
    try {
      await _storage.deleteItem(_getUserSpecificKey(CART_KEY));
      await _storage.deleteItem(_getUserSpecificKey(WISHLIST_KEY));
      await _storage.deleteItem(_getUserSpecificKey(RECENT_PRODUCTS_KEY));
      await _storage.deleteItem(_getUserSpecificKey(BROWSING_HISTORY_KEY));
      await _storage.deleteItem(_getUserSpecificKey(SEARCHED_PRODUCTS_KEY));
      return true;
    } catch (e) {
      print('Error clearing all user data: $e');
      return false;
    }
  }
}
