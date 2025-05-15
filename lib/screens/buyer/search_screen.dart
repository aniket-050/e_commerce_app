import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/controllers/product_controller.dart';
import 'package:e_commerce_app/controllers/cart_controller.dart';
import 'package:e_commerce_app/controllers/wishlist_controller.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'dart:io';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ProductController _productController = Get.find<ProductController>();
  final CartController _cartController = Get.find<CartController>();
  final WishlistController? _wishlistController =
      Get.find<WishlistController>();

  final TextEditingController _searchController = TextEditingController();
  String _viewType = 'grid'; // 'grid' or 'list'
  bool _isSearching = true;

  @override
  void initState() {
    super.initState();
    // Focus on search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final FocusNode _searchFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocus,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
          ),
          style: const TextStyle(color: Colors.black),
          autofocus: true,
          onChanged: (_) => setState(() {}),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
              });
            },
          ),
          IconButton(
            icon: Icon(_viewType == 'grid' ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _viewType = _viewType == 'grid' ? 'list' : 'grid';
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final products = _productController.allProducts;

              if (products.isEmpty) {
                return const Center(child: Text('No products available'));
              }

              // Apply search filter
              final searchText = _searchController.text.toLowerCase().trim();
              var filteredProducts = products;

              if (searchText.isNotEmpty) {
                filteredProducts =
                    filteredProducts
                        .where(
                          (p) =>
                              p.name.toLowerCase().contains(searchText) ||
                              (p.description?.toLowerCase().contains(
                                    searchText,
                                  ) ??
                                  false) ||
                              p.sellerName.toLowerCase().contains(searchText) ||
                              p.category.toLowerCase().contains(searchText),
                        )
                        .toList();
              }

              if (filteredProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No products found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      if (searchText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Try a different search term',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                    ],
                  ),
                );
              }

              // Grid View
              if (_viewType == 'grid') {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _buildProductCard(product);
                  },
                );
              }
              // List View
              else {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _buildProductListItem(product);
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(product) {
    final bool isInWishlist =
        _wishlistController?.isInWishlist(product.id) ?? false;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.productDetails, arguments: product);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: _buildProductImage(product),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isInWishlist ? Colors.red : Colors.grey,
                        size: 16,
                      ),
                      onPressed: () {
                        if (_wishlistController != null) {
                          _wishlistController!.toggleWishlist(product);
                          setState(() {});
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ],
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Seller: ${product.sellerName}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Add to Cart Button
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 55,
                    child: MaterialButton(
                      onPressed: () async {
                        _cartController.addToCart(product);
                        setState(() {});
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: AppTheme.primaryColor,
                      elevation: 3,
                      minWidth: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListItem(product) {
    final bool isInWishlist =
        _wishlistController?.isInWishlist(product.id) ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.productDetails, arguments: product);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildProductImage(product),
                ),
              ),

              const SizedBox(width: 12),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isInWishlist ? Colors.red : Colors.grey,
                            size: 16,
                          ),
                          onPressed: () {
                            if (_wishlistController != null) {
                              _wishlistController!.toggleWishlist(product);
                              setState(() {});
                            }
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Seller: ${product.sellerName}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    if (product.description != null)
                      Text(
                        product.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[800], fontSize: 12),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () async {
                              _cartController.addToCart(product);
                              setState(() {});
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            color: AppTheme.primaryColor,
                            elevation: 3,
                            minWidth: double.infinity,
                            height: 42,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
    );
  }

  Widget _buildProductImage(product) {
    // Helper function to get fallback image based on product category or name
    String getFallbackImage(product) {
      final category = product.category.toLowerCase();
      final name = product.name.toLowerCase();

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
          int.tryParse(product.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
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

    if (product.imageUrl == null || product.imageUrl.isEmpty) {
      final fallbackImage = getFallbackImage(product);

      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: Image.asset(
          fallbackImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Second fallback if the category-specific one fails
            return Image.asset(
              'assets/images/products/bt_speaker.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                );
              },
            );
          },
        ),
      );
    }

    // Handle local file paths (starting with /)
    if (product.imageUrl.startsWith('/')) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: Image.file(
          File(product.imageUrl),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            final fallbackImage = getFallbackImage(product);

            return Image.asset(
              fallbackImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/products/bt_speaker.png',
                  fit: BoxFit.cover,
                );
              },
            );
          },
        ),
      );
    }

    // Handle asset images
    if (product.imageUrl.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: Image.asset(
          product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            final fallbackImage = getFallbackImage(product);

            return Image.asset(
              fallbackImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                );
              },
            );
          },
        ),
      );
    }

    // Handle network images
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Image.network(
        product.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          final fallbackImage = getFallbackImage(product);

          return Image.asset(
            fallbackImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
              );
            },
          );
        },
      ),
    );
  }
}
