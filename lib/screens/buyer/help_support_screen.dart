import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/widgets/custom_button.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  // Mock data for FAQ
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I place an order?',
      'answer':
          'Browse products, add items to your cart, proceed to checkout, provide shipping and payment information, and confirm your order.',
    },
    {
      'question': 'How can I track my order?',
      'answer':
          'Go to "My Orders" in your profile to view the status and tracking information for all your orders.',
    },
    {
      'question': 'What payment methods are accepted?',
      'answer':
          'We accept credit/debit cards, PayPal, and other digital payment methods. You can manage your payment methods in your account settings.',
    },
    {
      'question': 'How do I return a product?',
      'answer':
          'Go to your order details, select "Return Item", follow the instructions to print a return label, and ship the item back within 30 days of delivery.',
    },
    {
      'question': 'How long does shipping take?',
      'answer':
          'Standard shipping typically takes 3-5 business days. Express shipping options are available at checkout for faster delivery.',
    },
    {
      'question': 'Do you ship internationally?',
      'answer':
          'Yes, we ship to most countries worldwide. Shipping costs and delivery times vary by location.',
    },
  ];

  // Active FAQ index (expanded)
  int? _activeIndex;

  // Contact form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Help & Support',
          bottom: const TabBar(
            tabs: [
              Tab(text: 'FAQ'),
              Tab(text: 'Contact Us'),
              Tab(text: 'Live Chat'),
            ],
            indicatorColor: AppTheme.primaryColor,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [_buildFaqTab(), _buildContactTab(), _buildLiveChatTab()],
        ),
      ),
    );
  }

  Widget _buildFaqTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Find answers to common questions about our services',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ...List.generate(_faqs.length, (index) {
            return _buildFaqItem(index);
          }),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Still need help?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'If you couldn\'t find what you\'re looking for, please contact our support team.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: 'Contact Support',
            onPressed: () {
              DefaultTabController.of(context).animateTo(1);
            },
            icon: Icons.email,
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(int index) {
    final isActive = _activeIndex == index;
    final faq = _faqs[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ExpansionTile(
        initiallyExpanded: isActive,
        onExpansionChanged: (expanded) {
          setState(() {
            _activeIndex = expanded ? index : null;
          });
        },
        title: Text(
          faq['question']!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  faq['answer']!,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fill out the form below and we\'ll get back to you as soon as possible',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!GetUtils.isEmail(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'What can we help you with?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.help),
              ),
              hint: const Text('Select a topic'),
              items: const [
                DropdownMenuItem(value: 'order', child: Text('Order Issues')),
                DropdownMenuItem(
                  value: 'payment',
                  child: Text('Payment Issues'),
                ),
                DropdownMenuItem(
                  value: 'shipping',
                  child: Text('Shipping & Delivery'),
                ),
                DropdownMenuItem(
                  value: 'return',
                  child: Text('Returns & Refunds'),
                ),
                DropdownMenuItem(
                  value: 'account',
                  child: Text('Account Issues'),
                ),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) {},
              validator: (value) {
                if (value == null) {
                  return 'Please select a topic';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your message';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            CustomButton(
              label: 'Submit Request',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // In a real app, send the support request
                  Get.snackbar(
                    'Request Submitted',
                    'We\'ll get back to you soon!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );

                  // Clear form
                  _nameController.clear();
                  _emailController.clear();
                  _messageController.clear();
                }
              },
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Contact Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildContactInfoItem(
              icon: Icons.email,
              title: 'Email Us',
              subtitle: 'support@example.com',
            ),
            _buildContactInfoItem(
              icon: Icons.phone,
              title: 'Call Us',
              subtitle: '+1 (123) 456-7890',
            ),
            _buildContactInfoItem(
              icon: Icons.access_time,
              title: 'Business Hours',
              subtitle: 'Monday to Friday, 9:00 AM - 6:00 PM',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveChatTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat,
              size: 60,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Live Chat Support',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Our support team is available to help you with any questions or concerns.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: CustomButton(
              label: 'Start Chat',
              onPressed: () {
                Get.snackbar(
                  'Coming Soon',
                  'Live chat will be available in a future update',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: Icons.chat_bubble,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Available: Monday to Friday, 9:00 AM - 6:00 PM',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}
