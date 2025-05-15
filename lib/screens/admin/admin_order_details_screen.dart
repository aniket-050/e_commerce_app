import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/models/order_model.dart';
import 'package:e_commerce_app/controllers/order_controller.dart';
import 'package:e_commerce_app/controllers/user_controller.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'dart:io';

class AdminOrderDetailsScreen extends StatefulWidget {
  const AdminOrderDetailsScreen({super.key});

  @override
  State<AdminOrderDetailsScreen> createState() =>
      _AdminOrderDetailsScreenState();
}

class _AdminOrderDetailsScreenState extends State<AdminOrderDetailsScreen> {
  final OrderController _orderController = Get.find<OrderController>();
  final UserController _userController = Get.find<UserController>();

  late Order _order;

  @override
  void initState() {
    super.initState();
    _order = Get.arguments as Order;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final buyer = _userController.getUserById(_order.buyerId);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Order Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #${_order.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              _order.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _order.status.capitalize!,
                            style: TextStyle(
                              color: _getStatusColor(_order.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Date: ${_order.createdAt.toString().substring(0, 10)} ${_order.createdAt.toString().substring(11, 16)}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          '\$${_order.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Buyer Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buyer Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        if (buyer != null) {
                          Get.toNamed(
                            AppRoutes.adminBuyerDetails,
                            arguments: buyer,
                          );
                        }
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppTheme.primaryColor.withOpacity(
                              0.1,
                            ),
                            child:
                                buyer?.profileImageUrl != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.asset(
                                        buyer!.profileImageUrl!,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
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
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  buyer?.username ?? _order.buyerName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  buyer?.email ?? 'N/A',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  buyer?.phone ?? 'No phone provided',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Order Items
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Items',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _order.items.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = _order.items[index];
                        final seller = _userController.getUserById(
                          item.sellerId,
                        );

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: _buildProductImage(item),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Quantity: ${item.quantity}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    InkWell(
                                      onTap: () {
                                        if (seller != null) {
                                          Get.toNamed(
                                            AppRoutes.adminSellerDetails,
                                            arguments: seller,
                                          );
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.store,
                                            size: 14,
                                            color: AppTheme.primaryColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'Seller: ${seller?.businessName ?? 'Unknown Seller'}',
                                              style: const TextStyle(
                                                color: AppTheme.primaryColor,
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Total: \$${(item.price * item.quantity).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal:', style: TextStyle(fontSize: 14)),
                        Text(
                          '\$${_order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Shipping:', style: TextStyle(fontSize: 14)),
                        Text(
                          '\$5.00',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${(_order.totalAmount + 5.0).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Order Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Actions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _showUpdateStatusDialog(context);
                            },
                            child: const Text('Update Status'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_order.status == 'pending')
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _updateOrderStatus('completed');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Mark as Completed'),
                            ),
                          ),
                        if (_order.status != 'cancelled')
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _updateOrderStatus('cancelled');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Cancel Order'),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateStatusDialog(BuildContext context) {
    String newStatus = _order.status;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Order Status'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('Pending'),
                    value: 'pending',
                    groupValue: newStatus,
                    activeColor: Colors.orange,
                    onChanged: (value) {
                      setState(() {
                        newStatus = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Completed'),
                    value: 'completed',
                    groupValue: newStatus,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        newStatus = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Cancelled'),
                    value: 'cancelled',
                    groupValue: newStatus,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      setState(() {
                        newStatus = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
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
                if (newStatus != _order.status) {
                  _updateOrderStatus(newStatus);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateOrderStatus(String newStatus) async {
    final success = _orderController.updateOrderStatus(_order.id, newStatus);

    if (await success) {
      // Refresh the order data
      setState(() {
        _order = _orderController.getOrderById(_order.id)!;
      });

      Get.snackbar(
        'Status Updated',
        'Order status updated to ${newStatus.capitalize}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: _getStatusColor(newStatus).withOpacity(0.1),
        colorText: _getStatusColor(newStatus),
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to update order status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Widget _buildProductImage(dynamic item) {
    // Helper function to get fallback image based on product name
    String getFallbackImage() {
      final name = item.productName.toLowerCase();

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
      if (name.contains('bag')) return 'assets/images/products/bag.png';
      if (name.contains('dress')) return 'assets/images/products/dress.png';
      if (name.contains('shoe')) return 'assets/images/products/shoes.png';
      if (name.contains('pillow'))
        return 'assets/images/products/Decorative_Throw_Pillows.png';
      if (name.contains('canvas') || name.contains('art'))
        return 'assets/images/products/Wall_Art_Canvas.png';

      // Default fallback based on product ID to ensure variety
      final int id =
          int.tryParse(item.productId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
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

    // Use fallback image based on product name
    final fallbackImage = getFallbackImage();

    return Image.asset(
      fallbackImage,
      height: 50,
      width: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print("Error loading fallback image: $error");
        return const Center(
          child: Icon(Icons.broken_image, color: Colors.grey, size: 24),
        );
      },
    );
  }
}
