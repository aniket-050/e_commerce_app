import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/controllers/product_controller.dart';
import 'package:e_commerce_app/controllers/order_controller.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'dart:io';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final ProductController _productController = Get.find<ProductController>();
  final OrderController _orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.person, color: AppTheme.primaryColor),
              onPressed: () {
                Get.toNamed(AppRoutes.sellerProfile);
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Cards
                Row(
                  children: [
                    _buildStatCard(
                      icon: Icons.grid_view,
                      title: 'Products',
                      value:
                          _productController.sellerProducts.length.toString(),
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      icon: Icons.shopping_cart,
                      title: 'Orders',
                      value: _orderController.userOrders.length.toString(),
                      color: AppTheme.secondaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                      icon: Icons.star,
                      title: 'Revenue',
                      value:
                          '\$${_orderController.calculateTotalSales().toStringAsFixed(2)}k',
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      icon: Icons.star,
                      title: 'Rating',
                      value: '4.8',
                      color: AppTheme.accentColor,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Products
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.sellerProducts);
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() {
                  // This displays only the products of the currently logged-in seller
                  // The filtering is done in ProductController.loadProducts() method
                  if (_productController.sellerProducts.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'No products found. Add your first product!',
                        ),
                      ),
                    );
                  }

                  final displayProducts =
                      _productController.sellerProducts.take(2).toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayProducts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:
                                  product.imageUrl != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child:
                                            product.imageUrl!.startsWith('/')
                                                ? Image.file(
                                                  File(product.imageUrl!),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    print(
                                                      "Error loading file image: $error",
                                                    );
                                                    return const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                    );
                                                  },
                                                )
                                                : product.imageUrl!.startsWith(
                                                  'http',
                                                )
                                                ? Image.network(
                                                  product.imageUrl!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    print(
                                                      "Error loading network image: $error",
                                                    );
                                                    return const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                    );
                                                  },
                                                )
                                                : Image.asset(
                                                  product.imageUrl!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    print(
                                                      "Error loading asset image: $error",
                                                    );
                                                    return const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                    );
                                                  },
                                                ),
                                      )
                                      : const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                            ),
                            title: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                            ),
                            trailing: Text(
                              product.category,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.editProduct,
                                arguments: product,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () {
          Get.toNamed(AppRoutes.addProduct);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on Dashboard
              break;
            case 1:
              Get.toNamed(AppRoutes.sellerProducts);
              break;
            case 2:
              Get.toNamed(AppRoutes.sellerOrders);
              break;
            case 3:
              Get.toNamed(AppRoutes.sellerProfile);
              break;
          }
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
