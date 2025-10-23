import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';

class PaymentScreen extends StatelessWidget {
  final String orderId;
  final String paymentMethod;
  final double etbAmount;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.paymentMethod,
    required this.etbAmount,
  });

  Map<String, dynamic> _getPaymentInstructions() {
    switch (paymentMethod) {
      case 'Telebirr':
        return {
          'steps': [
            'Open your Telebirr app',
            'Select "Send Money" or "Transfer"',
            'Enter the merchant number: 0912345678',
            'Enter amount: ${Formatters.formatETB(etbAmount)}',
            'Add reference: Order #${orderId.substring(0, 8)}',
            'Complete the payment',
            'Take a screenshot of the confirmation',
          ],
          'accountNumber': '0912345678',
          'accountName': 'BitBirr Merchant',
        };
      case 'CBE Birr':
        return {
          'steps': [
            'Open CBE Birr app',
            'Select "Transfer to CBE Birr"',
            'Enter merchant number: 0923456789',
            'Enter amount: ${Formatters.formatETB(etbAmount)}',
            'Add remark: Order #${orderId.substring(0, 8)}',
            'Confirm and complete payment',
            'Save the transaction receipt',
          ],
          'accountNumber': '0923456789',
          'accountName': 'BitBirr CBE',
        };
      case 'Awash Bank':
        return {
          'steps': [
            'Visit Awash Bank branch or use online banking',
            'Deposit to Account: 01234567890123',
            'Amount: ${Formatters.formatETB(etbAmount)}',
            'Reference: Order #${orderId.substring(0, 8)}',
            'Keep the deposit slip',
          ],
          'accountNumber': '01234567890123',
          'accountName': 'BitBirr Trading PLC',
        };
      default:
        return {
          'steps': ['Contact support for payment instructions'],
          'accountNumber': 'N/A',
          'accountName': 'N/A',
        };
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final instructions = _getPaymentInstructions();
    final steps = instructions['steps'] as List<String>;
    final accountNumber = instructions['accountNumber'] as String;
    final accountName = instructions['accountName'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Instructions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order summary
            Card(
              color: AppTheme.darkNavy,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Order ID', orderId.substring(0, 8)),
                    _buildInfoRow('Amount', Formatters.formatETB(etbAmount)),
                    _buildInfoRow('Payment Method', paymentMethod),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Payment details
            const Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Account Number'),
                      subtitle: Text(
                        accountNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () => _copyToClipboard(
                          context,
                          accountNumber,
                          'Account number',
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Account Name'),
                      subtitle: Text(
                        accountName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Amount'),
                      subtitle: Text(
                        Formatters.formatETB(etbAmount),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () => _copyToClipboard(
                          context,
                          etbAmount.toStringAsFixed(2),
                          'Amount',
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Reference'),
                      subtitle: Text(
                        'Order #${orderId.substring(0, 8)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () => _copyToClipboard(
                          context,
                          'Order #${orderId.substring(0, 8)}',
                          'Reference',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Step by step instructions
            const Text(
              'Step-by-Step Instructions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ...steps.asMap().entries.map((entry) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 24),

            // Important notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[700]),
                      const SizedBox(width: 12),
                      const Text(
                        'Important',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• Make sure to include the order reference in your payment\n'
                    '• Payment processing may take 15-30 minutes\n'
                    '• You will receive crypto within 24 hours after payment confirmation\n'
                    '• Contact support if you face any issues',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Done button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/orders',
                  (route) => route.settings.name == '/home',
                );
              },
              child: const Text('I have completed the payment'),
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
