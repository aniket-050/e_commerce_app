import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/utils/dummy_data.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/utils/file_upload_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  final RxList<Product> _allProducts = <Product>[].obs;
  final RxList<Product> _sellerProducts = <Product>[].obs;

  // Loading state
  final RxBool _isUploading = false.obs;

  // Key for storing products in SharedPreferences
  static const String PRODUCTS_KEY = 'local_products';

  List<Product> get allProducts => _allProducts;
  List<Product> get sellerProducts => _sellerProducts;
  bool get isUploading => _isUploading.value;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      // Try to load products from SharedPreferences first
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? storedProductsJson = prefs.getString(PRODUCTS_KEY);

      List<Product> products = [];
      if (storedProductsJson != null && storedProductsJson.isNotEmpty) {
        // Parse stored products
        final List<dynamic> decodedList = jsonDecode(storedProductsJson);
        products = decodedList.map((item) => Product.fromJson(item)).toList();
      } else {
        // Fall back to dummy data if nothing is stored yet
        products = DummyData.products;
        // Save dummy data to shared preferences for future use
        await _saveProductsToPrefs(products);
      }

      List<Product> sellerProductsList = [];
      // If current user is a seller, load their products
      if (_authController.isSeller && _authController.currentUser != null) {
        // Filter products to only show products from the currently logged-in seller
        // This ensures sellers can only see and manage their own products
        sellerProductsList =
            products
                .where((p) => p.sellerId == _authController.currentUser!.id)
                .toList();
      }

      // Update in the next frame to avoid setState during build
      Future.microtask(() {
        _allProducts.value = products;
        _sellerProducts.value = sellerProductsList;
      });
    } catch (e) {
      print('Error loading products: $e');
      // Fall back to dummy data if there's an error
      final products = DummyData.products;

      List<Product> sellerProductsList = [];
      if (_authController.isSeller && _authController.currentUser != null) {
        sellerProductsList = DummyData.getProductsBySellerId(
          _authController.currentUser!.id,
        );
      }

      _allProducts.value = products;
      _sellerProducts.value = sellerProductsList;
    }
  }

  // Save products to SharedPreferences
  Future<void> _saveProductsToPrefs(List<Product> products) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> productMapList =
          products.map((product) => product.toJson()).toList();
      final String productsJson = jsonEncode(productMapList);
      await prefs.setString(PRODUCTS_KEY, productsJson);
    } catch (e) {
      print('Error saving products to SharedPreferences: $e');
    }
  }

  // Method to get product details by ID
  Product? getProductById(String productId) {
    try {
      return _allProducts.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  // Method to upload product image and get URL
  Future<String?> uploadProductImage(File imageFile) async {
    try {
      _isUploading.value = true;
      print("ProductController: Starting image upload: ${imageFile.path}");

      // Verify that the file exists
      if (!await imageFile.exists()) {
        print(
          "ProductController: Image file does not exist at path: ${imageFile.path}",
        );
        _isUploading.value = false;
        return null;
      }

      // Use the FileUploadService to save the image
      final String? localPath = await FileUploadService.saveFileToLocalStorage(
        imageFile,
        customDir: 'product_images',
      );

      print("ProductController: Image uploaded, local path: $localPath");
      _isUploading.value = false;
      return localPath;
    } catch (e) {
      print('ProductController: Error uploading product image: $e');
      _isUploading.value = false;
      return null;
    }
  }

  // Method to add a new product
  Future<bool> addProduct({
    required String name,
    required double price,
    required String description,
    required String category,
    String? imageUrl,
  }) async {
    if (!_authController.isSeller || _authController.currentUser == null) {
      return false;
    }

    try {
      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        price: price,
        description: description,
        imageUrl: imageUrl,
        category: category,
        sellerId: _authController.currentUser!.id,
        sellerName:
            _authController.currentUser!.businessName ??
            _authController.currentUser!.username,
        isActive: true,
        createdAt: DateTime.now(),
      );

      // Add to all products
      final updatedProducts = [..._allProducts, newProduct];
      _allProducts.value = updatedProducts;

      // Add to seller products
      final updatedSellerProducts = [..._sellerProducts, newProduct];
      _sellerProducts.value = updatedSellerProducts;

      // Save to SharedPreferences
      await _saveProductsToPrefs(updatedProducts);

      return true;
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }

  // Method to update an existing product
  Future<bool> updateProduct({
    required String productId,
    required String name,
    required double price,
    required String description,
    required String category,
    String? imageUrl,
  }) async {
    if (!_authController.isSeller || _authController.currentUser == null) {
      return false;
    }

    try {
      final productIndex = _allProducts.indexWhere((p) => p.id == productId);

      if (productIndex == -1) {
        return false;
      }

      final oldProduct = _allProducts[productIndex];

      // Ensure the seller owns this product
      if (oldProduct.sellerId != _authController.currentUser!.id) {
        return false;
      }

      final updatedProduct = Product(
        id: oldProduct.id,
        name: name,
        price: price,
        description: description,
        imageUrl: imageUrl ?? oldProduct.imageUrl,
        category: category,
        sellerId: oldProduct.sellerId,
        sellerName: oldProduct.sellerName,
        isActive: oldProduct.isActive,
        createdAt: oldProduct.createdAt,
      );

      // Update in all products
      final List<Product> updatedAllProducts = [..._allProducts];
      updatedAllProducts[productIndex] = updatedProduct;
      _allProducts.value = updatedAllProducts;

      // Update in seller products
      final sellerProductIndex = _sellerProducts.indexWhere(
        (p) => p.id == productId,
      );
      if (sellerProductIndex != -1) {
        final List<Product> updatedSellerProducts = [..._sellerProducts];
        updatedSellerProducts[sellerProductIndex] = updatedProduct;
        _sellerProducts.value = updatedSellerProducts;
      }

      // Save to SharedPreferences
      await _saveProductsToPrefs(updatedAllProducts);

      return true;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }

  // Method to toggle product active status
  Future<bool> toggleProductStatus(String productId) async {
    if (!_authController.isSeller || _authController.currentUser == null) {
      return false;
    }

    try {
      final productIndex = _allProducts.indexWhere((p) => p.id == productId);

      if (productIndex == -1) {
        return false;
      }

      final oldProduct = _allProducts[productIndex];

      // Ensure the seller owns this product
      if (oldProduct.sellerId != _authController.currentUser!.id) {
        return false;
      }

      final updatedProduct = Product(
        id: oldProduct.id,
        name: oldProduct.name,
        price: oldProduct.price,
        description: oldProduct.description,
        imageUrl: oldProduct.imageUrl,
        category: oldProduct.category,
        sellerId: oldProduct.sellerId,
        sellerName: oldProduct.sellerName,
        isActive: !oldProduct.isActive, // Toggle active status
        createdAt: oldProduct.createdAt,
      );

      // Update in all products
      final List<Product> updatedAllProducts = [..._allProducts];
      updatedAllProducts[productIndex] = updatedProduct;
      _allProducts.value = updatedAllProducts;

      // Update in seller products
      final sellerProductIndex = _sellerProducts.indexWhere(
        (p) => p.id == productId,
      );
      if (sellerProductIndex != -1) {
        final List<Product> updatedSellerProducts = [..._sellerProducts];
        updatedSellerProducts[sellerProductIndex] = updatedProduct;
        _sellerProducts.value = updatedSellerProducts;
      }

      // Save to SharedPreferences
      await _saveProductsToPrefs(updatedAllProducts);

      return true;
    } catch (e) {
      print('Error toggling product status: $e');
      return false;
    }
  }

  // Method to delete a product
  Future<bool> deleteProduct(String productId) async {
    if (!_authController.isSeller || _authController.currentUser == null) {
      return false;
    }

    try {
      final productIndex = _allProducts.indexWhere((p) => p.id == productId);

      if (productIndex == -1) {
        return false;
      }

      final product = _allProducts[productIndex];

      // Ensure the seller owns this product
      if (product.sellerId != _authController.currentUser!.id) {
        return false;
      }

      // Remove from all products
      final List<Product> updatedAllProducts = [..._allProducts];
      updatedAllProducts.removeAt(productIndex);
      _allProducts.value = updatedAllProducts;

      // Remove from seller products
      _sellerProducts.removeWhere((p) => p.id == productId);

      // Save to SharedPreferences
      await _saveProductsToPrefs(updatedAllProducts);

      return true;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // Method to get products by category
  List<Product> getProductsByCategory(String category) {
    return _allProducts.where((p) => p.category == category).toList();
  }
}
