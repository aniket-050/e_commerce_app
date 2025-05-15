import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/controllers/product_controller.dart';
import 'package:e_commerce_app/controllers/cart_controller.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/product_card.dart';
import 'package:e_commerce_app/controllers/wishlist_controller.dart';
import 'dart:io';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final ProductController _productController = Get.find<ProductController>();
  final CartController _cartController = Get.find<CartController>();

  // Try to find WishlistController if registered
  late final WishlistController? _wishlistController;

  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _viewType = 'grid'; // 'grid' or 'list'

  final List<String> _categories = [
    'All',
    'Electronics',
    'Fashion',
    'Home & Kitchen',
    'Beauty & Personal Care',
    'Sports & Outdoors',
    'Books',
    'Toys & Games',
    'Health & Wellness',
    'Automotive',
    'Accessories',
    'Other',
  ];

  final List<Map<String, dynamic>> _featuredProducts = [
    {'title': 'All', 'icon': Icons.grid_view, 'color': AppTheme.primaryColor},
    {'title': 'Deals', 'icon': Icons.local_offer, 'color': Colors.orange},
    {'title': 'Popular', 'icon': Icons.favorite, 'color': Colors.pink},
    {'title': 'Recent', 'icon': Icons.shopping_cart, 'color': Colors.teal},
  ];

  @override
  void initState() {
    super.initState();
    // Try to find wishlist controller if it exists
    _wishlistController = Get.find<WishlistController>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            !_isSearching
                ? const Text('Discover')
                : TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search products...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Categories
            // Container(
            //   height: 60,
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: _featuredProducts.length,
            //     itemBuilder: (context, index) {
            //       final item = _featuredProducts[index];
            //       final isSelected = _selectedCategory == item['title'];
            //
            //       return GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             _selectedCategory = item['title'];
            //           });
            //         },
            //         child: Container(
            //           margin: EdgeInsets.only(
            //             left: index == 0 ? 16 : 8,
            //             right: index == _featuredProducts.length - 1 ? 16 : 8,
            //           ),
            //           padding: const EdgeInsets.symmetric(horizontal: 16),
            //           decoration: BoxDecoration(
            //             color: isSelected ? item['color'] : Colors.grey[200],
            //             borderRadius: BorderRadius.circular(30),
            //           ),
            //           child: Row(
            //             children: [
            //               Icon(
            //                 item['icon'],
            //                 color: isSelected ? Colors.white : Colors.grey[600],
            //                 size: 18,
            //               ),
            //               const SizedBox(width: 8),
            //               Text(
            //                 item['title'],
            //                 style: TextStyle(
            //                   color:
            //                       isSelected ? Colors.white : Colors.grey[600],
            //                   fontWeight:
            //                       isSelected
            //                           ? FontWeight.bold
            //                           : FontWeight.normal,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            // Featured Products Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Featured Products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/products/wireless_earbuds.jpeg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Premium Headphones',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '\$199.99',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Grid/List
            Expanded(
              child: Obx(() {
                final products = _productController.allProducts;

                if (products.isEmpty) {
                  return const Center(child: Text('No products available'));
                }

                // Filter products
                var filteredProducts = products;

                // Apply category filter
                if (_selectedCategory != 'All') {
                  filteredProducts =
                      filteredProducts
                          .where((p) => p.category == _selectedCategory)
                          .toList();
                }

                // Apply search filter
                final searchText = _searchController.text.toLowerCase().trim();
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
                                p.sellerName.toLowerCase().contains(searchText),
                          )
                          .toList();
                }

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
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
                              'Try changing your search query',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        if (_selectedCategory != 'All')
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedCategory = 'All';
                                });
                              },
                              child: const Text('Clear category filter'),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on Home
              break;
            case 1:
              // Navigate to the dedicated search screen
              Get.toNamed(AppRoutes.search);
              break;
            case 2:
              Get.toNamed(AppRoutes.cart);
              break;
            case 3:
              Get.toNamed(AppRoutes.buyerProfile);
              break;
          }
        },
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    // vertical: 5,
                  ),
                  child: SizedBox(
                    height: 55,
                    child: MaterialButton(
                      onPressed: () {
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
                          fontSize: 12,
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
                            onPressed: () {
                              _cartController.addToCart(product);
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
                                fontSize: 16,
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
            print("Error loading primary fallback image: $error");
            // Second fallback if the category-specific one fails
            return Image.asset(
              'assets/images/products/bt_speaker.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading secondary fallback image: $error");
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
            print("Error loading file image: $error");
            final fallbackImage = getFallbackImage(product);

            return Image.asset(
              fallbackImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading fallback image: $error");
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
            print("Error loading asset image: $error");
            final fallbackImage = getFallbackImage(product);

            return Image.asset(
              fallbackImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading fallback image: $error");
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
          print("Error loading network image: $error");
          final fallbackImage = getFallbackImage(product);

          return Image.asset(
            fallbackImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print("Error loading fallback image: $error");
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
