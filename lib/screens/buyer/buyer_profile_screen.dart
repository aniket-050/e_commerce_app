import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/controllers/order_controller.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'dart:io';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final OrderController _orderController = Get.find<OrderController>();

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

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Profile'),
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
                              child: Image.file(
                                File(user.profileImageUrl!),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: AppTheme.primaryColor,
                                  );
                                },
                              ),
                            )
                            : const Icon(
                              Icons.person,
                              size: 50,
                              color: AppTheme.primaryColor,
                            ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.username,
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
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Account Options
            const Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            _buildOptionTile(
              icon: Icons.person,
              title: 'Edit Profile',
              onTap: () {
                Get.toNamed(AppRoutes.editProfile);
              },
            ),
            _buildOptionTile(
              icon: Icons.location_on,
              title: 'Shipping Addresses',
              onTap: () {
                Get.toNamed(AppRoutes.shippingAddresses);
              },
            ),
            _buildOptionTile(
              icon: Icons.payment,
              title: 'Payment Methods',
              onTap: () {
                Get.toNamed(AppRoutes.paymentMethods);
              },
            ),

            // const SizedBox(height: 24),
            // const Text(
            //   'Orders',
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            // ),
            // const SizedBox(height: 16),
            // _buildOptionTile(
            //   icon: Icons.receipt_long,
            //   title: 'My Orders',
            //   onTap: () {
            //     Get.toNamed(AppRoutes.buyerOrders);
            //   },
            // ),

            // const SizedBox(height: 24),
            // const Text(
            //   'Preferences',
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            // ),
            // const SizedBox(height: 16),
            // _buildOptionTile(
            //   icon: Icons.notifications,
            //   title: 'Notifications',
            //   onTap: () {
            //     Get.toNamed(AppRoutes.buyerNotifications);
            //   },
            // ),
            // _buildOptionTile(
            //   icon: Icons.language,
            //   title: 'Language',
            //   onTap: () {
            //     Get.toNamed(AppRoutes.language);
            //   },
            // ),
            // _buildOptionTile(
            //   icon: Icons.dark_mode,
            //   title: 'Dark Mode',
            //   trailing: Switch(
            //     value:
            //         false, // In a real app, this would be controlled by a theme controller
            //     onChanged: (value) {
            //       // In a real app, toggle dark mode
            //       Get.snackbar(
            //         'Coming Soon',
            //         'This feature will be available soon',
            //         snackPosition: SnackPosition.BOTTOM,
            //       );
            //     },
            //     activeColor: AppTheme.primaryColor,
            //   ),
            //   onTap: () {},
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
                Get.toNamed(AppRoutes.buyerHelpSupport);
              },
            ),
            _buildOptionTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              onTap: () {
                Get.toNamed(AppRoutes.privacyPolicy);
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
