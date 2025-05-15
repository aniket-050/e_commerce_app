import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Notification settings
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _payments = true;
  bool _appUpdates = false;
  bool _newArrivals = true;

  // Mock notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Order #1234 Shipped',
      'message': 'Your order has been shipped and will arrive in 2-3 days.',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': true,
      'type': 'order',
    },
    {
      'id': '2',
      'title': 'Special Offer',
      'message': 'Get 20% off on all electronics until this weekend!',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': false,
      'type': 'promotion',
    },
    {
      'id': '3',
      'title': 'Payment Successful',
      'message': 'Your payment of \$129.99 for order #1234 was successful.',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'type': 'payment',
    },
    {
      'id': '4',
      'title': 'App Update Available',
      'message':
          'A new version of the app is available with exciting features.',
      'time': DateTime.now().subtract(const Duration(days: 3)),
      'isRead': false,
      'type': 'app',
    },
    {
      'id': '5',
      'title': 'New Products Available',
      'message': 'Check out the latest smartphones in our store.',
      'time': DateTime.now().subtract(const Duration(days: 5)),
      'isRead': true,
      'type': 'new_arrival',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Notifications',
          bottom: const TabBar(
            tabs: [Tab(text: 'All'), Tab(text: 'Settings')],
            indicatorColor: AppTheme.primaryColor,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [_buildNotificationsTab(), _buildSettingsTab()],
        ),
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return _notifications.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];
            return _buildNotificationCard(notification, index);
          },
        );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No notifications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'You\'re all caught up!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    IconData iconData;
    Color iconColor;

    switch (notification['type']) {
      case 'order':
        iconData = Icons.shopping_bag;
        iconColor = Colors.blue;
        break;
      case 'promotion':
        iconData = Icons.local_offer;
        iconColor = Colors.orange;
        break;
      case 'payment':
        iconData = Icons.payment;
        iconColor = Colors.green;
        break;
      case 'app':
        iconData = Icons.system_update;
        iconColor = Colors.purple;
        break;
      case 'new_arrival':
        iconData = Icons.new_releases;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.grey;
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            notification['isRead']
                ? BorderSide.none
                : const BorderSide(color: AppTheme.primaryColor, width: 1),
      ),
      color:
          notification['isRead']
              ? Colors.white
              : AppTheme.primaryColor.withOpacity(0.05),
      child: InkWell(
        onTap: () {
          setState(() {
            _notifications[index]['isRead'] = true;
          });

          // Show notification details
          _showNotificationDetails(notification);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontWeight:
                                  notification['isRead']
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _getTimeAgo(notification['time']),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification['message'],
                      style: TextStyle(color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose which notifications you want to receive',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          _buildSettingsSwitchTile(
            title: 'Order Updates',
            subtitle: 'Get notified about order status changes',
            value: _orderUpdates,
            onChanged: (value) {
              setState(() {
                _orderUpdates = value;
              });
            },
            icon: Icons.shopping_bag,
            iconColor: Colors.blue,
          ),

          _buildSettingsSwitchTile(
            title: 'Promotions & Offers',
            subtitle: 'Receive special offers and discounts',
            value: _promotions,
            onChanged: (value) {
              setState(() {
                _promotions = value;
              });
            },
            icon: Icons.local_offer,
            iconColor: Colors.orange,
          ),

          _buildSettingsSwitchTile(
            title: 'Payment Updates',
            subtitle: 'Get notified about payment activities',
            value: _payments,
            onChanged: (value) {
              setState(() {
                _payments = value;
              });
            },
            icon: Icons.payment,
            iconColor: Colors.green,
          ),

          _buildSettingsSwitchTile(
            title: 'App Updates',
            subtitle: 'Be informed about new app features and updates',
            value: _appUpdates,
            onChanged: (value) {
              setState(() {
                _appUpdates = value;
              });
            },
            icon: Icons.system_update,
            iconColor: Colors.purple,
          ),

          _buildSettingsSwitchTile(
            title: 'New Arrivals',
            subtitle: 'Get notified when new products are added',
            value: _newArrivals,
            onChanged: (value) {
              setState(() {
                _newArrivals = value;
              });
            },
            icon: Icons.new_releases,
            iconColor: Colors.red,
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          InkWell(
            onTap: () {
              _showClearConfirmation();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Clear All Notifications',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(notification['title']),
            content: Text(notification['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Notifications'),
            content: const Text(
              'Are you sure you want to clear all notifications?',
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
                  setState(() {
                    _notifications.clear();
                  });
                  Navigator.pop(context);

                  Get.snackbar(
                    'Success',
                    'All notifications cleared',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
