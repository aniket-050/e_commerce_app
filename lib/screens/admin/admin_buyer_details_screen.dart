import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/models/user_model.dart';
import 'package:e_commerce_app/controllers/order_controller.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/utils/app_theme.dart';

class AdminBuyerDetailsScreen extends StatefulWidget {
  const AdminBuyerDetailsScreen({super.key});

  @override
  State<AdminBuyerDetailsScreen> createState() =>
      _AdminBuyerDetailsScreenState();
}

class _AdminBuyerDetailsScreenState extends State<AdminBuyerDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrderController _orderController = Get.find<OrderController>();

  late User _buyer;

  @override
  void initState() {
    super.initState();
    _buyer = Get.arguments as User;
    _tabController = TabController(length: 2, vsync: this);

    // Refresh orders
    _orderController.loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders =
        _orderController.allOrders
            .where((o) => o.buyerId == _buyer.id)
            .toList();

    // Calculate total spent
    double totalSpent = 0;
    for (final order in orders) {
      totalSpent += order.totalAmount;
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Buyer Details'),
      body: Column(
        children: [
          // Buyer Header Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Buyer Profile Image
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child:
                          _buyer.profileImageUrl != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.asset(
                                  _buyer.profileImageUrl!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: AppTheme.primaryColor,
                                    );
                                  },
                                ),
                              )
                              : const Icon(
                                Icons.person,
                                size: 40,
                                color: AppTheme.primaryColor,
                              ),
                    ),
                    const SizedBox(width: 16),

                    // Buyer Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _buyer.username,
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
                                _buyer.email,
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
                                _buyer.phone ?? 'No phone provided',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Buyer',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Stats Cards
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildStatCard(
                      'Orders',
                      orders.length.toString(),
                      Icons.receipt,
                      Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Total Spent',
                      '\$${totalSpent.toStringAsFixed(2)}',
                      Icons.attach_money,
                      Colors.green,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Last Order',
                      orders.isNotEmpty ? '2 days ago' : 'Never',
                      Icons.access_time,
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

  Widget _buildOrdersTab(List<dynamic> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('No orders found for this buyer'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

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
                const SizedBox(height: 12),
                const Divider(),
                ...order.items.map(
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
                      'Total: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
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
          _buildInfoItem('Username', _buyer.username),
          _buildInfoItem('Email', _buyer.email),
          _buildInfoItem('Phone', _buyer.phone ?? 'Not provided'),
          _buildInfoItem('Role', 'Buyer'),
          _buildInfoItem('Account ID', _buyer.id),
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

  String _capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
