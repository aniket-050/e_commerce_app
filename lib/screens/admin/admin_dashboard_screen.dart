import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/controllers/user_controller.dart';
import 'package:e_commerce_app/controllers/product_controller.dart';
import 'package:e_commerce_app/controllers/order_controller.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:e_commerce_app/utils/app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final UserController _userController = Get.find<UserController>();
  final ProductController _productController = Get.find<ProductController>();
  final OrderController _orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    // Use post-frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userController.loadUsers();
      _orderController.loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authController.logout();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Message
                Text(
                  'Welcome, ${_authController.currentUser?.username ?? 'Admin'}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Cards
                Row(
                  children: [
                    _buildStatCard(
                      'Sellers',
                      _userController.sellerCount.toString(),
                      Icons.store,
                      Colors.blue,
                      () => Get.toNamed(AppRoutes.adminSellers),
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Buyers',
                      _userController.buyerCount.toString(),
                      Icons.people,
                      Colors.green,
                      () => Get.toNamed(AppRoutes.adminBuyers),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                      'Products',
                      _productController.allProducts.length.toString(),
                      Icons.shopping_bag,
                      Colors.orange,
                      () => Get.toNamed(AppRoutes.adminProducts),
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Orders',
                      _orderController.allOrders.length.toString(),
                      Icons.receipt,
                      Colors.purple,
                      () => Get.toNamed(AppRoutes.adminOrders),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Recent Orders
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.adminOrders);
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildRecentOrdersList(),
                const SizedBox(height: 32),

                // New Sellers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Sellers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.adminSellers);
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildRecentSellersList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Sellers'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on Dashboard
              break;
            case 1:
              Get.toNamed(AppRoutes.adminSellers);
              break;
            case 2:
              Get.toNamed(AppRoutes.adminProducts);
              break;
            case 3:
              Get.toNamed(AppRoutes.adminOrders);
              break;
          }
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
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
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentOrdersList() {
    return Obx(() {
      final orders = _orderController.allOrders;

      if (orders.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No orders found'),
          ),
        );
      }

      // Display the 3 most recent orders
      final recentOrders = orders.take(3).toList();

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentOrders.length,
        itemBuilder: (context, index) {
          final order = recentOrders[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(
                'Order #${order.id}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'By ${order.buyerName} • ${order.createdAt.toString().substring(0, 10)}',
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
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
                  order.status.capitalize!,
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
              onTap: () {
                Get.toNamed(AppRoutes.adminOrderDetails, arguments: order);
              },
            ),
          );
        },
      );
    });
  }

  Widget _buildRecentSellersList() {
    return Obx(() {
      final sellers = _userController.allSellers;

      if (sellers.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No sellers found'),
          ),
        );
      }

      // Display the 3 most recent sellers
      final recentSellers = sellers.take(3).toList();

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentSellers.length,
        itemBuilder: (context, index) {
          final seller = recentSellers[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child:
                    seller.profileImageUrl != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            seller.profileImageUrl!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: AppTheme.primaryColor,
                              );
                            },
                          ),
                        )
                        : const Icon(
                          Icons.person,
                          color: AppTheme.primaryColor,
                        ),
              ),
              title: Text(
                seller.businessName ?? seller.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(seller.businessCategory ?? 'No category'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.toNamed(AppRoutes.adminSellerDetails, arguments: seller);
              },
            ),
          );
        },
      );
    });
  }
}
