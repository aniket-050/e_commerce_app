import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/utils/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _enableNotifications = true;
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _accountAlerts = true;

  // Mock notification data
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Order',
      'message': 'You received a new order for Wireless Earbuds',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
      'type': 'order',
    },
    {
      'title': 'Payment Received',
      'message': 'Payment of \$129.99 has been processed for order #125',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'isRead': false,
      'type': 'payment',
    },
    {
      'title': 'Order Delivered',
      'message': 'Order #123 has been delivered successfully',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'type': 'order',
    },
    {
      'title': 'Promotion Tip',
      'message': 'Add product descriptions to increase your sales by 30%',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'type': 'promotion',
    },
    {
      'title': 'Account Update',
      'message': 'Your profile has been updated successfully',
      'time': DateTime.now().subtract(const Duration(days: 3)),
      'isRead': true,
      'type': 'account',
    },
  ];

  void _toggleNotification(int index) {
    setState(() {
      _notifications[index]['isRead'] = true;
    });
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'payment':
        return Icons.payment;
      case 'promotion':
        return Icons.campaign;
      case 'account':
        return Icons.person;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'payment':
        return Colors.green;
      case 'promotion':
        return Colors.orange;
      case 'account':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Notifications'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Settings
              const Text(
                'Notification Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSettingsCard(),

              const SizedBox(height: 24),

              // Recent Notifications
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        for (final notification in _notifications) {
                          notification['isRead'] = true;
                        }
                      });
                    },
                    child: const Text('Mark all as read'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Notification List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return _buildNotificationCard(notification, index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Turn on/off all notifications'),
              value: _enableNotifications,
              activeColor: AppTheme.primaryColor,
              onChanged: (value) {
                setState(() {
                  _enableNotifications = value;
                  if (!value) {
                    _orderUpdates = false;
                    _promotions = false;
                    _accountAlerts = false;
                  }
                });
              },
            ),
            const Divider(),
            CheckboxListTile(
              title: const Text('Order Updates'),
              subtitle: const Text('Get notified about order status changes'),
              value: _enableNotifications && _orderUpdates,
              activeColor: AppTheme.primaryColor,
              onChanged:
                  _enableNotifications
                      ? (value) {
                        setState(() {
                          _orderUpdates = value!;
                        });
                      }
                      : null,
            ),
            CheckboxListTile(
              title: const Text('Promotions'),
              subtitle: const Text('Receive tips and promotional offers'),
              value: _enableNotifications && _promotions,
              activeColor: AppTheme.primaryColor,
              onChanged:
                  _enableNotifications
                      ? (value) {
                        setState(() {
                          _promotions = value!;
                        });
                      }
                      : null,
            ),
            CheckboxListTile(
              title: const Text('Account Alerts'),
              subtitle: const Text('Important updates about your account'),
              value: _enableNotifications && _accountAlerts,
              activeColor: AppTheme.primaryColor,
              onChanged:
                  _enableNotifications
                      ? (value) {
                        setState(() {
                          _accountAlerts = value!;
                        });
                      }
                      : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: notification['isRead'] ? null : Colors.blue.withOpacity(0.05),
      child: InkWell(
        onTap: () => _toggleNotification(index),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getColorForType(
                    notification['type'],
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconForType(notification['type']),
                  color: _getColorForType(notification['type']),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification['title'],
                          style: TextStyle(
                            fontWeight:
                                notification['isRead']
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _getTimeAgo(notification['time']),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'],
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    if (!notification['isRead']) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
