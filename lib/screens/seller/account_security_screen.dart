import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_button.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  bool _isChangingPassword = false;
  bool _isLoading = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _twoFactorEnabled = false;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Mock login history
  final List<Map<String, dynamic>> _loginHistory = [
    {
      'device': 'iPhone 12',
      'location': 'San Francisco, CA',
      'ip': '192.168.1.1',
      'time': DateTime.now().subtract(const Duration(minutes: 30)),
      'status': 'success',
    },
    {
      'device': 'Chrome on Windows',
      'location': 'San Francisco, CA',
      'ip': '192.168.1.1',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'success',
    },
    {
      'device': 'Safari on Mac',
      'location': 'New York, NY',
      'ip': '203.0.113.1',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'success',
    },
    {
      'device': 'Firefox on Linux',
      'location': 'Chicago, IL',
      'ip': '198.51.100.1',
      'time': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'failed',
    },
  ];

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordChange() {
    setState(() {
      _isChangingPassword = !_isChangingPassword;
      if (!_isChangingPassword) {
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    });
  }

  void _toggleTwoFactor() {
    setState(() {
      _twoFactorEnabled = !_twoFactorEnabled;
    });

    // Show confirmation message
    Get.snackbar(
      'Two-Factor Authentication',
      _twoFactorEnabled
          ? 'Two-factor authentication has been enabled.'
          : 'Two-factor authentication has been disabled.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _twoFactorEnabled ? Colors.green : Colors.orange,
      colorText: Colors.white,
    );
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would call an API to change the password
    setState(() {
      _isLoading = false;
      _isChangingPassword = false;
    });

    // Show success message
    Get.snackbar(
      'Success',
      'Your password has been changed successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Clear form fields
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
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
      appBar: const CustomAppBar(title: 'Account Security'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Settings
            const Text(
              'Security Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Password Section
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (!_isChangingPassword)
                          TextButton(
                            onPressed: _togglePasswordChange,
                            child: const Text('Change'),
                          ),
                      ],
                    ),
                    if (!_isChangingPassword) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.lock, size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          const Text(
                            'Last changed: ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '30 days ago',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _currentPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Current Password',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showCurrentPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showCurrentPassword =
                                          !_showCurrentPassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !_showCurrentPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your current password';
                                }
                                // In a real app, this would validate against the actual password
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _newPasswordController,
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showNewPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showNewPassword = !_showNewPassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !_showNewPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a new password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm New Password',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showConfirmPassword =
                                          !_showConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !_showConfirmPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your new password';
                                }
                                if (value != _newPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _togglePasswordChange,
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      side: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomButton(
                                    label: 'Save',
                                    onPressed: _changePassword,
                                    isLoading: _isLoading,
                                    width: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Two-Factor Authentication
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Two-Factor Authentication',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Add an extra layer of security to your account by requiring both your password and a verification code from your mobile phone.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Enable Two-Factor Authentication'),
                      value: _twoFactorEnabled,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (value) => _toggleTwoFactor(),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),

            // Recent Login Activity
            const SizedBox(height: 24),
            const Text(
              'Recent Login Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _loginHistory.length,
              itemBuilder: (context, index) {
                final session = _loginHistory[index];
                return _buildLoginActivityCard(session);
              },
            ),

            // Logout from all devices button
            const SizedBox(height: 16),
            CustomButton(
              label: 'Logout from all devices',
              onPressed: () {
                // Show confirmation dialog
                Get.dialog(
                  AlertDialog(
                    title: const Text('Logout from all devices?'),
                    content: const Text(
                      'This will log you out from all devices where you are currently logged in.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.snackbar(
                            'Success',
                            'You have been logged out from all devices.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
              isOutlined: true,
              backgroundColor: Colors.red,
              textColor: Colors.red,
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginActivityCard(Map<String, dynamic> session) {
    final isCurrent = session == _loginHistory.first;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    session['status'] == 'success'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                session['status'] == 'success'
                    ? Icons.check_circle
                    : Icons.error,
                color:
                    session['status'] == 'success' ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session['device'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${session['location']} • ${session['ip']}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTimeAgo(session['time']),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isCurrent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Current',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
