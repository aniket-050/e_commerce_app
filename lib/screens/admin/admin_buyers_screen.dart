import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/controllers/user_controller.dart';
import 'package:e_commerce_app/controllers/order_controller.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';

class AdminBuyersScreen extends StatefulWidget {
  const AdminBuyersScreen({super.key});

  @override
  State<AdminBuyersScreen> createState() => _AdminBuyersScreenState();
}

class _AdminBuyersScreenState extends State<AdminBuyersScreen> {
  final UserController _userController = Get.find<UserController>();
  final OrderController _orderController = Get.find<OrderController>();
  final TextEditingController _searchController = TextEditingController();
  
  RxBool isSearching = false.obs;
  
  @override
  void initState() {
    super.initState();
    _userController.loadUsers();
    _orderController.loadOrders();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  int _getOrderCount(String buyerId) {
    return _orderController.allOrders.where((order) => order.buyerId == buyerId).length;
  }
  
  double _getTotalSpent(String buyerId) {
    double total = 0;
    for (final order in _orderController.allOrders) {
      if (order.buyerId == buyerId) {
        total += order.totalAmount;
      }
    }
    return total;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Buyers',
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
                        hintText: 'Search buyers...',
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
          
          // Stats Summary
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              final buyers = _userController.allBuyers;
              
              return Row(
                children: [
                  _buildStatCard(
                    'Total Buyers',
                    buyers.length.toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    'Active Buyers',
                    buyers.where((buyer) => _getOrderCount(buyer.id) > 0).length.toString(),
                    Icons.shopping_cart,
                    Colors.green,
                  ),
                ],
              );
            }),
          ),
          
          // Buyers List
          Expanded(
            child: Obx(() {
              final buyers = _userController.allBuyers;
              
              if (buyers.isEmpty) {
                return const Center(
                  child: Text('No buyers found'),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: buyers.length,
                itemBuilder: (context, index) {
                  final buyer = buyers[index];
                  final orderCount = _getOrderCount(buyer.id);
                  final totalSpent = _getTotalSpent(buyer.id);
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.adminBuyerDetails,
                          arguments: buyer,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Buyer Profile Image
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                  child: buyer.profileImageUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(30),
                                          child: Image.asset(
                                            buyer.profileImageUrl!,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(Icons.person, size: 30, color: AppTheme.primaryColor);
                                            },
                                          ),
                                        )
                                      : const Icon(Icons.person, size: 30, color: AppTheme.primaryColor),
                                ),
                                const SizedBox(width: 16),
                                
                                // Buyer Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        buyer.username,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        buyer.email,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        buyer.phone ?? 'No phone provided',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            
                            // Order Stats
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildOrderStat(
                                  'Orders',
                                  orderCount.toString(),
                                  Icons.receipt,
                                ),
                                _buildOrderStat(
                                  'Total Spent',
                                  '\$${totalSpent.toStringAsFixed(2)}',
                                  Icons.attach_money,
                                ),
                                _buildOrderStat(
                                  'Last Order',
                                  orderCount > 0 ? '2 days ago' : 'Never',
                                  Icons.access_time,
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
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 40,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOrderStat(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
} 