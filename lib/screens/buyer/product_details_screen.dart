import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/controllers/cart_controller.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'dart:io';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final CartController _cartController = Get.find<CartController>();

  late Product _product;
  int _quantity = 1;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _product = Get.arguments as Product;
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // In a real app, would update a favorites list in a controller
    Get.snackbar(
      _isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
      _isFavorite
          ? 'Product added to your favorites'
          : 'Product removed from your favorites',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _isFavorite ? Colors.green[100] : Colors.grey[100],
      colorText: _isFavorite ? Colors.green[800] : Colors.grey[800],
      duration: const Duration(seconds: 2),
    );
  }

  void _addToCart() {
    for (int i = 0; i < _quantity; i++) {
      _cartController.addToCart(_product);
    }

    Get.snackbar(
      'Added to Cart',
      '${_product.name} x $_quantity added to your cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
      duration: const Duration(seconds: 2),
      mainButton: TextButton(
        onPressed: () {
          Get.toNamed(AppRoutes.cart);
        },
        child: const Text('VIEW CART'),
      ),
    );
  }

  Widget _buildProductImage() {
    // Helper function to get fallback image based on product category or name
    String getFallbackImage() {
      final category = _product.category.toLowerCase();
      final name = _product.name.toLowerCase();

      if (category == 'electronics' ||
          name.contains('headphone') ||
          name.contains('earbuds') ||
          name.contains('speaker')) {
        if (name.contains('headphone'))
          return 'assets/images/products/premium_headphones.png';
        if (name.contains('earbuds'))
          return 'assets/images/products/wireless_earbuds.jpeg';
        if (name.contains('speaker'))
          return 'assets/images/products/bt_speaker.png';
        if (name.contains('mouse'))
          return 'assets/images/products/mouse_wireless.png';
        if (name.contains('watch'))
          return 'assets/images/products/smart_watch.jpeg';
        return 'assets/images/products/bt_speaker.png';
      } else if (category == 'fashion' || category == 'accessories') {
        if (name.contains('bag')) return 'assets/images/products/bag.png';
        if (name.contains('dress')) return 'assets/images/products/dress.png';
        if (name.contains('shoe')) return 'assets/images/products/shoes.png';
        if (name.contains('watch')) return 'assets/images/products/watch.png';
        return 'assets/images/products/bag.png';
      } else if (category == 'home & decor' || category.contains('decor')) {
        if (name.contains('pillow'))
          return 'assets/images/products/Decorative_Throw_Pillows.png';
        if (name.contains('canvas') || name.contains('art'))
          return 'assets/images/products/Wall_Art_Canvas.png';
        return 'assets/images/products/Decorative_Throw_Pillows.png';
      }

      // Default fallback based on product ID to ensure variety
      final int id =
          int.tryParse(_product.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final List<String> allImages = [
        'assets/images/products/bt_speaker.png',
        'assets/images/products/watch.png',
        'assets/images/products/bag.png',
        'assets/images/products/shoes.png',
        'assets/images/products/wireless_earbuds.jpeg',
        'assets/images/products/Wall_Art_Canvas.png',
      ];

      return allImages[id % allImages.length];
    }

    if (_product.imageUrl == null || _product.imageUrl!.isEmpty) {
      final fallbackImage = getFallbackImage();

      return Image.asset(
        fallbackImage,
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading primary fallback image: $error");
          // Second fallback if the category-specific one fails
          return Image.asset(
            'assets/images/products/bt_speaker.png',
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print("Error loading secondary fallback image: $error");
              return const Center(
                child: Icon(Icons.broken_image, color: Colors.grey, size: 80),
              );
            },
          );
        },
      );
    }

    // Handle local file paths (starting with /)
    if (_product.imageUrl!.startsWith('/')) {
      return Image.file(
        File(_product.imageUrl!),
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading file image: $error");
          final fallbackImage = getFallbackImage();

          return Image.asset(
            fallbackImage,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print("Error loading fallback image: $error");
              return const Center(
                child: Icon(Icons.broken_image, color: Colors.grey, size: 80),
              );
            },
          );
        },
      );
    }

    // Handle asset images
    if (_product.imageUrl!.startsWith('assets/')) {
      return Image.asset(
        _product.imageUrl!,
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading asset image: $error");
          final fallbackImage = getFallbackImage();

          return Image.asset(
            fallbackImage,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print("Error loading fallback image: $error");
              return const Center(
                child: Icon(Icons.broken_image, color: Colors.grey, size: 80),
              );
            },
          );
        },
      );
    }

    // Handle network images
    if (_product.imageUrl!.startsWith('http')) {
      return Image.network(
        _product.imageUrl!,
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading network image: $error");
          final fallbackImage = getFallbackImage();

          return Image.asset(
            fallbackImage,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print("Error loading fallback image: $error");
              return const Center(
                child: Icon(Icons.broken_image, color: Colors.grey, size: 80),
              );
            },
          );
        },
      );
    }

    // For other unexpected formats
    print("Unknown image path format: ${_product.imageUrl}");
    final fallbackImage = getFallbackImage();

    return Image.asset(
      fallbackImage,
      width: double.infinity,
      height: 300,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print("Error loading fallback image: $error");
        return const Center(
          child: Icon(Icons.broken_image, color: Colors.grey, size: 80),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Product Details',
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Get.toNamed(AppRoutes.cart);
                },
              ),
              Obx(() {
                if (_cartController.itemCount <= 0) {
                  return const SizedBox.shrink();
                }
                return Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _cartController.itemCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Product Details
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildProductImage(),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: Icon(
                                  _isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _isFavorite ? Colors.red : null,
                                ),
                                onPressed: _toggleFavorite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Product Info
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _product.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '\$${_product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sold by ${_product.sellerName}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _product.category,
                                  style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '4.8 (120)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _product.description ?? 'No description available',
                            style: TextStyle(
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Quantity',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: _decrementQuantity,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      _quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: _incrementQuantity,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Bar with Add to Cart Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chat, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _addToCart,
                        child: const Text('Add to Cart'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
