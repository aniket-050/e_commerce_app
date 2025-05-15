import 'package:flutter/material.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_button.dart';
import 'package:get/get.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  // Mock FAQ data
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I add a new product?',
      'answer':
          'To add a new product, go to the Products tab and click on the "+" button. Fill in the product details and click Save.',
      'isExpanded': false,
    },
    {
      'question': 'How do I track my orders?',
      'answer':
          'You can track your orders in the Orders tab. Click on any order to see its details and current status.',
      'isExpanded': false,
    },
    {
      'question': 'How do I get paid?',
      'answer':
          'You will receive payments directly to your bank account based on your payout schedule. You can update your payment settings in the Account section.',
      'isExpanded': false,
    },
    {
      'question': 'How do I respond to customer reviews?',
      'answer':
          'You can respond to customer reviews by going to the Reviews section in your Products tab. Click on the review and add your response.',
      'isExpanded': false,
    },
    {
      'question': 'What fees will I be charged?',
      'answer':
          'We charge a 5% fee on each sale. There are no monthly subscription fees. You can view your fee breakdown in the Reports section.',
      'isExpanded': false,
    },
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _toggleFaqExpansion(int index) {
    setState(() {
      _faqs[index]['isExpanded'] = !_faqs[index]['isExpanded'];
    });
  }

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    // Show success message and clear form
    Get.snackbar(
      'Ticket Submitted',
      'We have received your support ticket and will respond to you shortly.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    _subjectController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Help & Support'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Support Section
            const Text(
              'Contact Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Submit a Ticket',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Our support team will get back to you within 24 hours.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _subjectController,
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          hintText: 'e.g. Payment issue, Product listing, etc.',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a subject';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          hintText: 'Please describe your issue in detail...',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a message';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        label: 'Submit Ticket',
                        onPressed: _submitTicket,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // // Support Options Section
            // const SizedBox(height: 32),
            // const Text(
            //   'Support Options',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 16),
            // _buildSupportOptionsCard(),

            // FAQ Section
            const SizedBox(height: 32),
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._faqs.asMap().entries.map((entry) {
              final index = entry.key;
              final faq = entry.value;
              return _buildFaqCard(faq, index);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOptionsCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.chat, color: Colors.white),
            ),
            title: const Text('Live Chat'),
            subtitle: const Text('Available Monday-Friday, 9am-5pm'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.snackbar(
                'Coming Soon',
                'Live chat will be available in the next app update.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(Icons.phone, color: Colors.white),
            ),
            title: const Text('Phone Support'),
            subtitle: const Text('+1 (800) 123-4567'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // In a real app, this would open the phone dialer
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.email, color: Colors.white),
            ),
            title: const Text('Email Support'),
            subtitle: const Text('support@shopeasy.com'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // In a real app, this would open the email app
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFaqCard(Map<String, dynamic> faq, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          faq['question'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        initiallyExpanded: faq['isExpanded'],
        onExpansionChanged: (expanded) {
          _toggleFaqExpansion(index);
        },
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(faq['answer'], style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
