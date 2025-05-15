import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/controllers/order_controller.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';

class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen> {
  final OrderController _orderController = Get.find<OrderController>();
  final AuthController _authController = Get.find<AuthController>();
  final RxString selectedFilter = 'All'.obs;

  @override
  void initState() {
    super.initState();
    _orderController.loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Orders'),
      body: Column(
        children: [
          // Filter options
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Completed'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Cancelled'),
                ],
              ),
            ),
          ),

          // Stats Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              final orders = _getSellerOrders();
              final pendingCount =
                  orders.where((o) => o.status == 'pending').length;
              final completedCount =
                  orders.where((o) => o.status == 'completed').length;
              final cancelledCount =
                  orders.where((o) => o.status == 'cancelled').length;

              double totalRevenue = 0;
              for (final order in orders) {
                if (order.status == 'completed') {
                  // Calculate revenue only from items sold by this seller
                  for (final item in order.items) {
                    if (item.sellerId == _authController.currentUser?.id) {
                      totalRevenue += (item.price * item.quantity);
                    }
                  }
                }
              }

              return Row(
                children: [
                  _buildStatCard(
                    'Total Orders',
                    orders.length.toString(),
                    Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    'Revenue',
                    '\$${totalRevenue.toStringAsFixed(2)}',
                    Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    'Pending',
                    pendingCount.toString(),
                    Colors.orange,
                  ),
                ],
              );
            }),
          ),

          // Orders list
          Expanded(
            child: Obx(() {
              final allOrders = _getSellerOrders();

              if (allOrders.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No orders found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              // Filter orders if needed
              var filteredOrders = allOrders;
              if (selectedFilter.value != 'All') {
                filteredOrders =
                    allOrders
                        .where(
                          (order) =>
                              order.status.toLowerCase() ==
                              selectedFilter.value.toLowerCase(),
                        )
                        .toList();
              }

              if (filteredOrders.isEmpty) {
                return Center(
                  child: Text(
                    'No ${selectedFilter.value} orders found',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];

                  // Calculate total for this seller's items only
                  double sellerTotal = 0;
                  for (final item in order.items) {
                    if (item.sellerId == _authController.currentUser?.id) {
                      sellerTotal += (item.price * item.quantity);
                    }
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.sellerOrderDetails,
                          arguments: order,
                        );
                      },
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
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      order.status,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    order.status.capitalize!,
                                    style: TextStyle(
                                      color: _getStatusColor(order.status),
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
                                  Icons.person,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Buyer: ${order.buyerName}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Date: ${order.createdAt.toString().substring(0, 10)}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.shopping_bag,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Your Items: ${order.items.where((item) => item.sellerId == _authController.currentUser?.id).length}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Your Revenue:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${sellerTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            if (order.status == 'pending') ...[
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _showUpdateStatusDialog(order.id);
                                    },
                                    child: const Text('Update Status'),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
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

  List<dynamic> _getSellerOrders() {
    // Filter orders to only include those with items from this seller
    final sellerId = _authController.currentUser?.id;
    return _orderController.allOrders.where((order) {
      return order.items.any((item) => item.sellerId == sellerId);
    }).toList();
  }

  Widget _buildFilterChip(String label) {
    return Obx(() {
      final isSelected = selectedFilter.value == label;

      return FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          selectedFilter.value = label;
        },
        backgroundColor: Colors.grey[200],
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      );
    });
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
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

  void _showUpdateStatusDialog(String orderId) {
    final currentStatus =
        _orderController.getOrderById(orderId)?.status ?? 'pending';
    String newStatus = currentStatus;

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
                if (newStatus != currentStatus) {
                  _orderController.updateOrderStatus(orderId, newStatus);

                  Get.snackbar(
                    'Status Updated',
                    'Order status updated to ${newStatus.capitalize}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: _getStatusColor(
                      newStatus,
                    ).withOpacity(0.1),
                    colorText: _getStatusColor(newStatus),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
