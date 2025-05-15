import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/models/user_model.dart';
import 'package:e_commerce_app/controllers/product_controller.dart';
import 'package:e_commerce_app/controllers/order_controller.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/product_card.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'dart:io';

class AdminSellerDetailsScreen extends StatefulWidget {
  const AdminSellerDetailsScreen({super.key});

  @override
  State<AdminSellerDetailsScreen> createState() =>
      _AdminSellerDetailsScreenState();
}

class _AdminSellerDetailsScreenState extends State<AdminSellerDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ProductController _productController = Get.find<ProductController>();
  final OrderController _orderController = Get.find<OrderController>();

  late User _seller;

  @override
  void initState() {
    super.initState();
    _seller = Get.arguments as User;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products =
        _productController.allProducts
            .where((p) => p.sellerId == _seller.id)
            .toList();
    final orders =
        _orderController.allOrders
            .where((o) => o.items.any((i) => i.sellerId == _seller.id))
            .toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Seller Details'),
      body: Column(
        children: [
          // Seller Header Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seller Profile Image
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child:
                          _seller.profileImageUrl != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: _buildProfileImage(),
                              )
                              : const Icon(
                                Icons.person,
                                size: 40,
                                color: AppTheme.primaryColor,
                              ),
                    ),
                    const SizedBox(width: 16),

                    // Seller Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _seller.businessName ?? _seller.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.mail,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _seller.email,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _seller.phone ?? 'No phone provided',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          if (_seller.businessCategory != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _seller.businessCategory!,
                                  style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Business Description
                if (_seller.businessDescription != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Business Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _seller.businessDescription!,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],

                // Business Address
                if (_seller.businessAddress != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Business Address',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _seller.businessAddress!,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ],

                // Stats Cards
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildStatCard(
                      'Products',
                      products.length.toString(),
                      Icons.shopping_bag,
                      Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Orders',
                      orders.length.toString(),
                      Icons.receipt,
                      Colors.green,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Revenue',
                      '\$${_calculateTotalRevenue(orders)}',
                      Icons.attach_money,
                      Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryColor,
              tabs: const [
                Tab(text: 'Products', icon: Icon(Icons.shopping_bag)),
                Tab(text: 'Orders', icon: Icon(Icons.receipt)),
                Tab(text: 'Info', icon: Icon(Icons.info)),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Products Tab
                _buildProductsTab(products),

                // Orders Tab
                _buildOrdersTab(orders),

                // Info Tab
                _buildInfoTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsTab(List<dynamic> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No products found for this seller'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.productDetails, arguments: product);
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: _buildProductImage(product),
                ),

                // Product Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.category,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductImage(dynamic product) {
    // Helper function to get fallback image based on product category or name
    String getFallbackImage() {
      final category = product.category.toLowerCase();
      final name = product.name.toLowerCase();

      if (category.contains('electronic') ||
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
      } else if (category.contains('fashion') ||
          category.contains('accessories')) {
        if (name.contains('bag')) return 'assets/images/products/bag.png';
        if (name.contains('dress')) return 'assets/images/products/dress.png';
        if (name.contains('shoe')) return 'assets/images/products/shoes.png';
        if (name.contains('watch')) return 'assets/images/products/watch.png';
        return 'assets/images/products/bag.png';
      } else if (category.contains('home') || category.contains('decor')) {
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
      final fallbackImage = getFallbackImage();

      return Image.asset(
        fallbackImage,
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading primary fallback image: $error");
          // Second fallback if the category-specific one fails
          return Image.asset(
            'assets/images/products/bt_speaker.png',
            height: 130,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print("Error loading secondary fallback image: $error");
              return _buildPlaceholderImage();
            },
          );
        },
      );
    }

    // Handle local file paths (starting with /)
    if (product.imageUrl.startsWith('/')) {
      return Image.file(
        File(product.imageUrl),
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading file image in AdminSellerDetailsScreen: $error");
          final fallbackImage = getFallbackImage();

          return Image.asset(
            fallbackImage,
            height: 130,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print("Error loading fallback image: $error");
              return _buildPlaceholderImage();
            },
          );
        },
      );
    }

    // Handle asset images
    if (product.imageUrl.startsWith('assets/')) {
      return Image.asset(
        product.imageUrl,
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print(
            "Error loading asset image in AdminSellerDetailsScreen: $error",
          );
          final fallbackImage = getFallbackImage();

          return Image.asset(
            fallbackImage,
            height: 130,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print("Error loading fallback image: $error");
              return _buildPlaceholderImage();
            },
          );
        },
      );
    }

    // Handle network images
    if (product.imageUrl.startsWith('http')) {
      return Image.network(
        product.imageUrl,
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print(
            "Error loading network image in AdminSellerDetailsScreen: $error",
          );
          final fallbackImage = getFallbackImage();

          return Image.asset(
            fallbackImage,
            height: 130,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print("Error loading fallback image: $error");
              return _buildPlaceholderImage();
            },
          );
        },
      );
    }

    // For other unexpected formats, use category-based fallback
    print(
      "Unknown image path format in AdminSellerDetailsScreen: ${product.imageUrl}",
    );
    final fallbackImage = getFallbackImage();

    return Image.asset(
      fallbackImage,
      height: 130,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print("Error loading fallback image: $error");
        return _buildPlaceholderImage();
      },
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 130,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Icon(Icons.image, size: 50, color: Colors.grey),
    );
  }

  Widget _buildOrdersTab(List<dynamic> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('No orders found for this seller'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        // Filter items for this seller only
        final sellerItems =
            order.items.where((item) => item.sellerId == _seller.id).toList();
        final sellerTotal = sellerItems.fold<double>(
          0.0,
          (double sum, dynamic item) => sum + (item.price * item.quantity),
        );

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            order.status == 'completed'
                                ? Colors.green.withOpacity(0.1)
                                : order.status == 'cancelled'
                                ? Colors.red.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _capitalizeFirstLetter(order.status),
                        style: TextStyle(
                          color:
                              order.status == 'completed'
                                  ? Colors.green
                                  : order.status == 'cancelled'
                                  ? Colors.red
                                  : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: ${order.createdAt.toString().substring(0, 10)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  'Buyer: ${order.buyerName}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                const Divider(),
                ...sellerItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.productName} (x${item.quantity})',
                          ),
                        ),
                        Text(
                          '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Seller Total: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${sellerTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
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
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildInfoItem('Username', _seller.username),
          _buildInfoItem('Email', _seller.email),
          _buildInfoItem('Phone', _seller.phone ?? 'Not provided'),
          _buildInfoItem('Role', 'Seller'),
          _buildInfoItem('Account ID', _seller.id),

          const SizedBox(height: 24),
          const Text(
            'Business Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            'Business Name',
            _seller.businessName ?? 'Not provided',
          ),
          _buildInfoItem(
            'Business Category',
            _seller.businessCategory ?? 'Not provided',
          ),
          _buildInfoItem(
            'Business Address',
            _seller.businessAddress ?? 'Not provided',
          ),
          _buildInfoItem(
            'Business Description',
            _seller.businessDescription ?? 'Not provided',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
          const Divider(),
        ],
      ),
    );
  }

  String _calculateTotalRevenue(List<dynamic> orders) {
    double total = 0;

    for (final order in orders) {
      for (final item in order.items) {
        if (item.sellerId == _seller.id) {
          total += (item.price * item.quantity);
        }
      }
    }

    return total.toStringAsFixed(2);
  }

  String _capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  Widget _buildProfileImage() {
    if (_seller.profileImageUrl == null || _seller.profileImageUrl!.isEmpty) {
      return const Icon(Icons.person, size: 40, color: AppTheme.primaryColor);
    }

    // Handle local file paths (starting with /)
    if (_seller.profileImageUrl!.startsWith('/')) {
      return Image.file(
        File(_seller.profileImageUrl!),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading seller profile file image: $error");
          return const Icon(
            Icons.person,
            size: 40,
            color: AppTheme.primaryColor,
          );
        },
      );
    }

    // Handle asset images
    if (_seller.profileImageUrl!.startsWith('assets/')) {
      return Image.asset(
        _seller.profileImageUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading seller profile asset image: $error");
          return const Icon(
            Icons.person,
            size: 40,
            color: AppTheme.primaryColor,
          );
        },
      );
    }

    // Handle network images
    if (_seller.profileImageUrl!.startsWith('http')) {
      return Image.network(
        _seller.profileImageUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading seller profile network image: $error");
          return const Icon(
            Icons.person,
            size: 40,
            color: AppTheme.primaryColor,
          );
        },
      );
    }

    // For other unexpected formats
    print(
      "Unknown seller profile image path format: ${_seller.profileImageUrl}",
    );
    return const Icon(Icons.person, size: 40, color: AppTheme.primaryColor);
  }
}
