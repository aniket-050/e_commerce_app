import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/controllers/product_controller.dart';
import 'package:e_commerce_app/controllers/user_controller.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'dart:io';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final ProductController _productController = Get.find<ProductController>();
  final UserController _userController = Get.find<UserController>();
  final TextEditingController _searchController = TextEditingController();

  RxBool isSearching = false.obs;
  RxString selectedCategory = 'All'.obs;
  RxString selectedSeller = 'All Sellers'.obs;

  final List<String> categories = [
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

  @override
  void initState() {
    super.initState();
    // Removed loadProducts() call to fix setState during build error
    // ProductController already calls loadProducts() in its onInit() method
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _getSellersList() {
    final List<String> sellerNames = ['All Sellers'];

    // Add unique seller names from all products
    _productController.allProducts.forEach((product) {
      if (!sellerNames.contains(product.sellerName)) {
        sellerNames.add(product.sellerName);
      }
    });

    return sellerNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Products',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching.value = !isSearching.value;
                if (!isSearching.value) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Obx(() {
            return isSearching.value
                ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      // Trigger search
                      setState(() {});
                    },
                  ),
                )
                : const SizedBox.shrink();
          }),

          // Filter Controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Row(
              children: [
                // Category Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory.value,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedCategory.value = newValue;
                      }
                    },
                    items:
                        categories.map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(width: 12),

                // Seller Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedSeller.value,
                    decoration: const InputDecoration(
                      labelText: 'Seller',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedSeller.value = newValue;
                      }
                    },
                    items:
                        _getSellersList().map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Products List
          Expanded(
            child: Obx(() {
              final allProducts = _productController.allProducts;

              if (allProducts.isEmpty) {
                return const Center(child: Text('No products found'));
              }

              // Filter products
              List<Product> filteredProducts = allProducts;

              // Filter by category
              if (selectedCategory.value != 'All') {
                filteredProducts =
                    filteredProducts
                        .where((p) => p.category == selectedCategory.value)
                        .toList();
              }

              // Filter by seller
              if (selectedSeller.value != 'All Sellers') {
                filteredProducts =
                    filteredProducts
                        .where((p) => p.sellerName == selectedSeller.value)
                        .toList();
              }

              // Filter by search text
              final searchText = _searchController.text.toLowerCase();
              if (searchText.isNotEmpty) {
                filteredProducts =
                    filteredProducts
                        .where(
                          (p) =>
                              p.name.toLowerCase().contains(searchText) ||
                              p.description?.toLowerCase().contains(
                                    searchText,
                                  ) ==
                                  true ||
                              p.sellerName.toLowerCase().contains(searchText),
                        )
                        .toList();
              }

              if (filteredProducts.isEmpty) {
                return Center(
                  child: Text('No products found with the selected filters'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  final seller = _userController.getUserById(product.sellerId);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                child: _buildProductImage(product),
                              ),
                              const SizedBox(width: 16),

                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                product.isActive
                                                    ? Colors.green.withOpacity(
                                                      0.1,
                                                    )
                                                    : Colors.red.withOpacity(
                                                      0.1,
                                                    ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            product.isActive
                                                ? 'Active'
                                                : 'Inactive',
                                            style: TextStyle(
                                              color:
                                                  product.isActive
                                                      ? Colors.green[700]
                                                      : Colors.red[700],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Seller Information
                                    InkWell(
                                      onTap: () {
                                        if (seller != null) {
                                          Get.toNamed(
                                            AppRoutes.adminSellerDetails,
                                            arguments: seller,
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryColor
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.store,
                                              size: 14,
                                              color: AppTheme.primaryColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Seller: ${product.sellerName}',
                                              style: const TextStyle(
                                                color: AppTheme.primaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      product.category,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    if (product.description != null &&
                                        product.description!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          product.description!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  // View product details
                                  Get.toNamed(
                                    AppRoutes.productDetails,
                                    arguments: product,
                                  );
                                },
                                icon: const Icon(Icons.visibility, size: 16),
                                label: const Text('View Details'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showProductActions(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  // In a real app, navigate to product details
                },
              ),
              ListTile(
                leading: Icon(
                  product.isActive ? Icons.unpublished : Icons.check_circle,
                  color: product.isActive ? Colors.red : Colors.green,
                ),
                title: Text(
                  product.isActive ? 'Mark as Inactive' : 'Mark as Active',
                ),
                onTap: () {
                  Navigator.pop(context);
                  // In a real app, update product status
                  _toggleProductStatus(product);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('View Seller'),
                onTap: () {
                  Navigator.pop(context);
                  // Find the seller and navigate to seller details
                  final seller = _userController.getUserById(product.sellerId);
                  if (seller != null) {
                    Get.toNamed('/admin/seller-details', arguments: seller);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleProductStatus(Product product) {
    // In a real app, this would update the product status in the database
    // For demo purposes, we can show a snackbar
    Get.snackbar(
      'Status Updated',
      product.isActive
          ? 'Product marked as inactive'
          : 'Product marked as active',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          product.isActive
              ? Colors.red.withOpacity(0.1)
              : Colors.green.withOpacity(0.1),
      colorText: product.isActive ? Colors.red : Colors.green,
    );
  }

  // Helper method to build product image based on image URL type
  Widget _buildProductImage(Product product) {
    // Helper function to get fallback image based on product category or name
    String getFallbackImage(Product product) {
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

    if (product.imageUrl == null || product.imageUrl!.isEmpty) {
      final fallbackImage = getFallbackImage(product);

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          fallbackImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading primary fallback image: $error");
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/products/bt_speaker.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print("Error loading secondary fallback image: $error");
                  return const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    }

    // Handle local file paths (starting with /)
    if (product.imageUrl!.startsWith('/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(product.imageUrl!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading file image in admin screen: $error");
            final fallbackImage = getFallbackImage(product);

            return Image.asset(
              fallbackImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading fallback image: $error");
                return const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                );
              },
            );
          },
        ),
      );
    }

    // Handle asset images
    if (product.imageUrl!.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          product.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading asset image in admin screen: $error");
            final fallbackImage = getFallbackImage(product);

            return Image.asset(
              fallbackImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading fallback image: $error");
                return const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                );
              },
            );
          },
        ),
      );
    }

    // Handle network images
    if (product.imageUrl!.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("Error loading network image in admin screen: $error");
            final fallbackImage = getFallbackImage(product);

            return Image.asset(
              fallbackImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading fallback image: $error");
                return const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                );
              },
            );
          },
        ),
      );
    }

    // For unknown image URL formats
    print("Unknown image path format in admin screen: ${product.imageUrl}");
    return Center(child: Icon(Icons.image, color: Colors.grey[400], size: 40));
  }
}
