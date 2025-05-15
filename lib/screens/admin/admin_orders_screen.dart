import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/controllers/order_controller.dart';
import 'package:e_commerce_app/controllers/user_controller.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/utils/app_theme.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final OrderController _orderController = Get.find<OrderController>();
  final UserController _userController = Get.find<UserController>();
  final TextEditingController _searchController = TextEditingController();
  
  RxBool isSearching = false.obs;
  RxString selectedStatus = 'All'.obs;
  
  final List<String> statuses = ['All', 'pending', 'completed', 'cancelled'];
  
  @override
  void initState() {
    super.initState();
    _orderController.loadOrders();
    _userController.loadUsers();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Orders',
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
                        hintText: 'Search orders...',
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
                        // In a real app, implement search functionality
                      },
                    ),
                  )
                : const SizedBox.shrink();
          }),
          
          // Status Filters
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: statuses.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  final status = statuses[index];
                  final isSelected = selectedStatus.value == status;
                  
                  return GestureDetector(
                    onTap: () {
                      selectedStatus.value = status;
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _getStatusColor(status).withOpacity(0.2)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        status == 'All' ? 'All' : status.capitalize!,
                        style: TextStyle(
                          color: isSelected
                              ? _getStatusColor(status)
                              : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          
          // Stats Summary
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              final orders = _orderController.allOrders;
              final pendingCount = orders.where((o) => o.status == 'pending').length;
              final completedCount = orders.where((o) => o.status == 'completed').length;
              final cancelledCount = orders.where((o) => o.status == 'cancelled').length;
              
              double totalRevenue = 0;
              for (final order in orders) {
                if (order.status == 'completed') {
                  totalRevenue += order.totalAmount;
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
          
          // Orders List
          Expanded(
            child: Obx(() {
              final allOrders = _orderController.allOrders;
              
              if (allOrders.isEmpty) {
                return const Center(
                  child: Text('No orders found'),
                );
              }
              
              // Filter orders by status if needed
              final filteredOrders = selectedStatus.value == 'All'
                  ? allOrders
                  : allOrders.where((o) => o.status == selectedStatus.value).toList();
              
              if (filteredOrders.isEmpty) {
                return Center(
                  child: Text('No ${selectedStatus.value} orders found'),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  final buyer = _userController.getUserById(order.buyerId);
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.adminOrderDetails,
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
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(order.status).withOpacity(0.1),
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
                                const Icon(Icons.person, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  'Buyer: ${buyer?.username ?? order.buyerName}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  'Date: ${order.createdAt.toString().substring(0, 10)}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.shopping_bag, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  'Items: ${order.items.length}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
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
                                  '\$${order.totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _updateOrderStatus(context, order.id, order.status);
                                  },
                                  child: const Text('Update Status'),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () {
                                    Get.toNamed(
                                      AppRoutes.adminOrderDetails,
                                      arguments: order,
                                    );
                                  },
                                  child: const Text('View Details'),
                                ),
                              ],
                            ),
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
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
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
  
  void _updateOrderStatus(BuildContext context, String orderId, String currentStatus) {
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
                  // In a real app, this would update the order status in the database
                  _orderController.updateOrderStatus(orderId, newStatus);
                  
                  Get.snackbar(
                    'Status Updated',
                    'Order status updated to ${newStatus.capitalize}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: _getStatusColor(newStatus).withOpacity(0.1),
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