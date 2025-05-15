import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/controllers/order_controller.dart';
import 'package:e_commerce_app/controllers/product_controller.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/routes/app_routes.dart';

class SellerProfileScreen extends StatefulWidget {
  const SellerProfileScreen({super.key});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final OrderController _orderController = Get.find<OrderController>();
  final ProductController _productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    _orderController.loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authController.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not found. Please login again.')),
      );
    }

    // Get seller-specific stats
    final products =
        _productController.allProducts
            .where((p) => p.sellerId == user.id)
            .toList();
    final orders =
        _orderController.allOrders
            .where((o) => o.items.any((item) => item.sellerId == user.id))
            .toList();

    double totalRevenue = 0;
    for (final order in orders) {
      if (order.status == 'completed') {
        for (final item in order.items) {
          if (item.sellerId == user.id) {
            totalRevenue += (item.price * item.quantity);
          }
        }
      }
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Seller Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child:
                        user.profileImageUrl != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                user.profileImageUrl!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.storefront,
                                    size: 50,
                                    color: AppTheme.primaryColor,
                                  );
                                },
                              ),
                            )
                            : const Icon(
                              Icons.storefront,
                              size: 50,
                              color: AppTheme.primaryColor,
                            ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.businessName ?? user.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  if (user.phone != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.phone!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                  if (user.businessCategory != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.businessCategory!,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Business Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(
                  'Products',
                  products.length.toString(),
                  Icons.shopping_bag,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Orders',
                  orders.length.toString(),
                  Icons.receipt,
                  Colors.orange,
                ),
                _buildStatCard(
                  'Revenue',
                  '\$${totalRevenue.toStringAsFixed(2)}',
                  Icons.attach_money,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Business Information
            if (user.businessDescription != null ||
                user.businessAddress != null) ...[
              const Text(
                'Business Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              if (user.businessDescription != null) ...[
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  user.businessDescription!,
                  style: TextStyle(color: Colors.grey[800]),
                ),
                const SizedBox(height: 16),
              ],
              if (user.businessAddress != null) ...[
                const Text(
                  'Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user.businessAddress!,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ],

            // Account Options
            const Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            _buildOptionTile(
              icon: Icons.store,
              title: 'Business Profile',
              onTap: () {
                // Navigate to the business profile screen
                Get.toNamed(AppRoutes.businessProfile);
              },
            ),
            _buildOptionTile(
              icon: Icons.shopping_bag,
              title: 'My Products',
              onTap: () {
                Get.toNamed(AppRoutes.sellerProducts);
              },
            ),
            _buildOptionTile(
              icon: Icons.receipt_long,
              title: 'My Orders',
              onTap: () {
                Get.toNamed(AppRoutes.sellerOrders);
              },
            ),

            const SizedBox(height: 24),
            const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            // _buildOptionTile(
            //   icon: Icons.notifications,
            //   title: 'Notifications',
            //   onTap: () {
            //     // Navigate to notifications screen
            //     Get.toNamed(AppRoutes.notifications);
            //   },
            // ),
            _buildOptionTile(
              icon: Icons.payment,
              title: 'Payment Settings',
              onTap: () {
                // Navigate to payment settings screen
                Get.toNamed(AppRoutes.paymentSettings);
              },
            ),
            // _buildOptionTile(
            //   icon: Icons.security,
            //   title: 'Account Security',
            //   onTap: () {
            //     // Navigate to account security screen
            //     Get.toNamed(AppRoutes.accountSecurity);
            //   },
            // ),

            const SizedBox(height: 24),
            const Text(
              'Other',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            _buildOptionTile(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {
                // Navigate to help and support screen
                Get.toNamed(AppRoutes.helpSupport);
              },
            ),
            _buildOptionTile(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                _showLogoutDialog();
              },
              textColor: Colors.red,
              iconColor: Colors.red,
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                'App Version 1.0.0',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _authController.logout();
              },
              child: const Text('Logout'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
