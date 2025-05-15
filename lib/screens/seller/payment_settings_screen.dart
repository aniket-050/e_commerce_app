import 'package:flutter/material.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_button.dart';

class PaymentSettingsScreen extends StatefulWidget {
  const PaymentSettingsScreen({super.key});

  @override
  State<PaymentSettingsScreen> createState() => _PaymentSettingsScreenState();
}

class _PaymentSettingsScreenState extends State<PaymentSettingsScreen> {
  int _selectedIndex = 0;
  bool _isAddingNew = false;
  bool _showBankForm = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _routingNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'bank',
      'name': 'Primary Bank Account',
      'bank': 'Bank of America',
      'accountNumber': '****6789',
      'isDefault': true,
    },
    {
      'type': 'card',
      'name': 'Business Credit Card',
      'cardType': 'Visa',
      'last4': '4242',
      'expiryDate': '09/25',
      'isDefault': false,
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  void _toggleAddNew() {
    setState(() {
      _isAddingNew = !_isAddingNew;
      _showBankForm = false;

      // Clear form fields when showing the form
      if (_isAddingNew) {
        _nameController.clear();
        _cardNumberController.clear();
        _expiryController.clear();
        _cvvController.clear();
        _bankNameController.clear();
        _accountNumberController.clear();
        _routingNumberController.clear();
        _accountHolderController.clear();
      }
    });
  }

  void _toggleBankForm() {
    setState(() {
      _showBankForm = !_showBankForm;
    });
  }

  void _setAsDefault(int index) {
    setState(() {
      for (int i = 0; i < _paymentMethods.length; i++) {
        _paymentMethods[i]['isDefault'] = (i == index);
      }
    });
  }

  void _deletePaymentMethod(int index) {
    setState(() {
      // If deleting the default method, make another one default
      if (_paymentMethods[index]['isDefault'] && _paymentMethods.length > 1) {
        _paymentMethods[index == 0 ? 1 : 0]['isDefault'] = true;
      }
      _paymentMethods.removeAt(index);
    });
  }

  Future<void> _addPaymentMethod() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (_showBankForm) {
      // Add bank account
      setState(() {
        _paymentMethods.add({
          'type': 'bank',
          'name': _nameController.text,
          'bank': _bankNameController.text,
          'accountNumber':
              '****${_accountNumberController.text.substring(_accountNumberController.text.length - 4)}',
          'isDefault':
              _paymentMethods.isEmpty, // Make default if it's the first method
        });
      });
    } else {
      // Add credit card
      setState(() {
        _paymentMethods.add({
          'type': 'card',
          'name': _nameController.text,
          'cardType':
              _cardNumberController.text.startsWith('4')
                  ? 'Visa'
                  : 'Mastercard',
          'last4': _cardNumberController.text.substring(
            _cardNumberController.text.length - 4,
          ),
          'expiryDate': _expiryController.text,
          'isDefault':
              _paymentMethods.isEmpty, // Make default if it's the first method
        });
      });
    }

    setState(() {
      _isLoading = false;
      _isAddingNew = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Payment Settings'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment methods section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Payment Methods',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (!_isAddingNew)
                    TextButton.icon(
                      onPressed: _toggleAddNew,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add New'),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Payment methods list
              if (_paymentMethods.isEmpty && !_isAddingNew)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No payment methods added yet'),
                  ),
                ),

              if (!_isAddingNew)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = _paymentMethods[index];
                    return _buildPaymentMethodCard(method, index);
                  },
                ),

              // Add new payment method form
              if (_isAddingNew) _buildAddPaymentMethodForm(),

              const SizedBox(height: 24),

              // // Payout settings section
              // const Text(
              //   'Payout Settings',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 16),
              // _buildPayoutSettingsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method, int index) {
    final isSelected = _selectedIndex == index;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        method['type'] == 'card'
                            ? Icons.credit_card
                            : Icons.account_balance,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        method['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  if (method['isDefault'])
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Default',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (method['type'] == 'card')
                Text(
                  '${method['cardType']} ending in ${method['last4']} (Expires: ${method['expiryDate']})',
                  style: TextStyle(color: Colors.grey[700]),
                )
              else
                Text(
                  '${method['bank']} - ${method['accountNumber']}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!method['isDefault'])
                    TextButton(
                      onPressed: () => _setAsDefault(index),
                      child: const Text('Set as Default'),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                    onPressed: () => _deletePaymentMethod(index),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddPaymentMethodForm() {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Payment Method',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _toggleAddNew,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Payment type toggle
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_showBankForm) _toggleBankForm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !_showBankForm
                                ? AppTheme.primaryColor
                                : Colors.grey[200],
                        foregroundColor:
                            !_showBankForm ? Colors.white : Colors.grey[700],
                        elevation: !_showBankForm ? 2 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Credit Card'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_showBankForm) _toggleBankForm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _showBankForm
                                ? AppTheme.primaryColor
                                : Colors.grey[200],
                        foregroundColor:
                            _showBankForm ? Colors.white : Colors.grey[700],
                        elevation: _showBankForm ? 2 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Bank Account'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name field for both card and bank
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  hintText: 'e.g. Business Card',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name for this payment method';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Card specific fields
              if (!_showBankForm) ...[
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    hintText: 'XXXX XXXX XXXX XXXX',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a card number';
                    }
                    if (value.length < 16) {
                      return 'Please enter a valid card number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryController,
                        decoration: const InputDecoration(
                          labelText: 'Expiry Date',
                          hintText: 'MM/YY',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          hintText: '123',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],

              // Bank specific fields
              if (_showBankForm) ...[
                TextFormField(
                  controller: _bankNameController,
                  decoration: const InputDecoration(
                    labelText: 'Bank Name',
                    hintText: 'e.g. Bank of America',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a bank name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _accountHolderController,
                  decoration: const InputDecoration(
                    labelText: 'Account Holder Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter account holder name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _accountNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Account Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an account number';
                    }
                    if (value.length < 8) {
                      return 'Please enter a valid account number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _routingNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Routing Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a routing number';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 24),
              CustomButton(
                label: 'Add Payment Method',
                onPressed: _addPaymentMethod,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPayoutSettingsCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payout Schedule',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose how often you would like to receive your payouts',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            RadioListTile(
              title: const Text('Daily'),
              subtitle: const Text('Receive your money every day'),
              value: 0,
              groupValue: 1,
              activeColor: AppTheme.primaryColor,
              onChanged: (value) {},
            ),
            RadioListTile(
              title: const Text('Weekly'),
              subtitle: const Text('Receive your money every Monday'),
              value: 1,
              groupValue: 1,
              activeColor: AppTheme.primaryColor,
              onChanged: (value) {},
            ),
            RadioListTile(
              title: const Text('Monthly'),
              subtitle: const Text(
                'Receive your money on the 1st of each month',
              ),
              value: 2,
              groupValue: 1,
              activeColor: AppTheme.primaryColor,
              onChanged: (value) {},
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Balance Available for Payout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  '\$1,245.67',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Request Instant Payout',
              onPressed: () {},
              backgroundColor: Colors.green,
              icon: Icons.flash_on,
            ),
          ],
        ),
      ),
    );
  }
}
