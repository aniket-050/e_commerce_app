import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/widgets/custom_button.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // Mock data for payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': '1',
      'type': 'credit_card',
      'brand': 'Visa',
      'last4': '4242',
      'expiryMonth': 12,
      'expiryYear': 2025,
      'isDefault': true,
    },
    {
      'id': '2',
      'type': 'credit_card',
      'brand': 'Mastercard',
      'last4': '5555',
      'expiryMonth': 8,
      'expiryYear': 2024,
      'isDefault': false,
    },
  ];

  int _selectedPaymentMethodIndex = 0;

  @override
  void initState() {
    super.initState();
    // Find the default payment method index
    for (int i = 0; i < _paymentMethods.length; i++) {
      if (_paymentMethods[i]['isDefault'] == true) {
        _selectedPaymentMethodIndex = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Payment Methods'),
      body: Column(
        children: [
          Expanded(
            child:
                _paymentMethods.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _paymentMethods.length,
                      itemBuilder: (context, index) {
                        final paymentMethod = _paymentMethods[index];
                        return _buildPaymentMethodCard(paymentMethod, index);
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomButton(
              label: 'Add Payment Method',
              onPressed: () {
                _showAddPaymentMethodDialog();
              },
              icon: Icons.add,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.credit_card_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No payment methods found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add a payment method to get started',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    Map<String, dynamic> paymentMethod,
    int index,
  ) {
    final isSelected = index == _selectedPaymentMethodIndex;
    final IconData cardIcon =
        paymentMethod['brand'] == 'Visa'
            ? Icons.credit_card
            : paymentMethod['brand'] == 'Mastercard'
            ? Icons.credit_card
            : Icons.credit_card;

    Color cardColor = Colors.blue;
    if (paymentMethod['brand'] == 'Mastercard') {
      cardColor = Colors.deepOrange;
    } else if (paymentMethod['brand'] == 'American Express') {
      cardColor = Colors.indigo;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(cardIcon, color: cardColor, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paymentMethod['brand'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '•••• ${paymentMethod['last4']}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const Spacer(),
                if (paymentMethod['isDefault'])
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Default',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Expires ${paymentMethod['expiryMonth']}/${paymentMethod['expiryYear']}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    // Edit payment method
                    _showEditPaymentMethodDialog(paymentMethod, index);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: 4),
                        Text('Edit'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    // Delete payment method with confirmation
                    _showDeleteConfirmation(paymentMethod, index);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 4),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                if (!paymentMethod['isDefault'])
                  TextButton(
                    onPressed: () {
                      setState(() {
                        // Update all payment methods to not be default
                        for (final method in _paymentMethods) {
                          method['isDefault'] = false;
                        }
                        // Set this payment method as default
                        _paymentMethods[index]['isDefault'] = true;
                        _selectedPaymentMethodIndex = index;
                      });
                    },
                    child: const Text('Set as default'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPaymentMethodDialog() {
    final cardNumberController = TextEditingController();
    final nameController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Payment Method'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: cardNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.credit_card),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 19,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name on Card',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: expiryController,
                          decoration: const InputDecoration(
                            labelText: 'MM/YY',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: cvvController,
                          decoration: const InputDecoration(
                            labelText: 'CVV',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.security),
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // In a real app, validate card details and tokenize with payment processor

                  // Add new payment method with mock data
                  setState(() {
                    _paymentMethods.add({
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'type': 'credit_card',
                      'brand':
                          'Visa', // Mock: in real app, detect from card number
                      'last4':
                          cardNumberController.text.isNotEmpty
                              ? cardNumberController.text.substring(
                                cardNumberController.text.length - 4,
                              )
                              : '0000',
                      'expiryMonth':
                          expiryController.text.isNotEmpty
                              ? int.tryParse(
                                    expiryController.text.split('/')[0],
                                  ) ??
                                  12
                              : 12,
                      'expiryYear':
                          expiryController.text.isNotEmpty
                              ? int.tryParse(
                                    '20${expiryController.text.split('/')[1]}',
                                  ) ??
                                  2025
                              : 2025,
                      'isDefault':
                          _paymentMethods
                              .isEmpty, // Make default if it's the first payment method
                    });
                  });
                  Navigator.pop(context);

                  Get.snackbar(
                    'Success',
                    'Payment method added successfully',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _showEditPaymentMethodDialog(
    Map<String, dynamic> paymentMethod,
    int index,
  ) {
    final expiryController = TextEditingController(
      text:
          '${paymentMethod['expiryMonth']}/${paymentMethod['expiryYear'].toString().substring(2)}',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Expiration Date'),
            content: TextField(
              controller: expiryController,
              decoration: const InputDecoration(
                labelText: 'MM/YY',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
              maxLength: 5,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Update payment method expiry date
                  if (expiryController.text.contains('/') &&
                      expiryController.text.split('/').length == 2) {
                    final parts = expiryController.text.split('/');
                    setState(() {
                      _paymentMethods[index] = {
                        ..._paymentMethods[index],
                        'expiryMonth':
                            int.tryParse(parts[0]) ??
                            _paymentMethods[index]['expiryMonth'],
                        'expiryYear':
                            int.tryParse('20${parts[1]}') ??
                            _paymentMethods[index]['expiryYear'],
                      };
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> paymentMethod, int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Payment Method'),
            content: Text(
              'Are you sure you want to delete this payment method?\n\n${paymentMethod['brand']} •••• ${paymentMethod['last4']}',
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
                    _paymentMethods.removeAt(index);

                    // If we deleted the selected payment method, select the first one
                    if (_selectedPaymentMethodIndex >= _paymentMethods.length) {
                      _selectedPaymentMethodIndex =
                          _paymentMethods.isNotEmpty ? 0 : -1;
                    }

                    // If we deleted the default payment method and there are other methods
                    if (paymentMethod['isDefault'] &&
                        _paymentMethods.isNotEmpty) {
                      _paymentMethods[0]['isDefault'] = true;
                    }
                  });
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
