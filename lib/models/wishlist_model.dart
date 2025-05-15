import 'package:e_commerce_app/models/product_model.dart';

class Wishlist {
  final String userId;
  final List<Product> products;

  Wishlist({required this.userId, List<Product>? products})
    : products = products ?? [];

  // Add a product to wishlist
  void addProduct(Product product) {
    if (!isProductInWishlist(product.id)) {
      products.add(product);
    }
  }

  // Remove a product from wishlist
  void removeProduct(String productId) {
    products.removeWhere((product) => product.id == productId);
  }

  // Check if a product is in the wishlist
  bool isProductInWishlist(String productId) {
    return products.any((product) => product.id == productId);
  }

  // Get the count of products in wishlist
  int get count => products.length;

  // Check if wishlist is empty
  bool get isEmpty => products.isEmpty;

  // Clear the wishlist
  void clear() {
    products.clear();
  }

  // Convert Wishlist to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  // Create Wishlist from JSON
  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      userId: json['userId'],
      products:
          (json['products'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .toList(),
    );
  }
}
