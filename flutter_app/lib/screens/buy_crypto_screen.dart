import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rates_provider.dart';
import '../providers/orders_provider.dart';
import '../utils/app_theme.dart';
import '../utils/validators.dart';
import '../utils/formatters.dart';

class BuyCryptoScreen extends StatefulWidget {
  const BuyCryptoScreen({super.key});

  @override
  State<BuyCryptoScreen> createState() => _BuyCryptoScreenState();
}

class _BuyCryptoScreenState extends State<BuyCryptoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _etbAmountController = TextEditingController();
  final _walletAddressController = TextEditingController();
  
  String _selectedAsset = 'BTC';
  String _selectedPaymentMethod = 'Telebirr';
  double _cryptoAmount = 0.0;

  final List<Map<String, dynamic>> _assets = [
    {'symbol': 'BTC', 'name': 'Bitcoin', 'icon': Icons.currency_bitcoin},
    {'symbol': 'ETH', 'name': 'Ethereum', 'icon': Icons.diamond},
    {'symbol': 'USDT', 'name': 'Tether USD', 'icon': Icons.attach_money},
  ];

  final List<String> _paymentMethods = [
    'Telebirr',
    'CBE Birr',
    'Awash Bank',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RatesProvider>(context, listen: false).fetchRates();
    });
    _etbAmountController.addListener(_calculateCryptoAmount);
  }

  @override
  void dispose() {
    _etbAmountController.dispose();
    _walletAddressController.dispose();
    super.dispose();
  }

  void _calculateCryptoAmount() {
    final etbAmount = double.tryParse(_etbAmountController.text) ?? 0.0;
    final ratesProvider = Provider.of<RatesProvider>(context, listen: false);
    setState(() {
      _cryptoAmount = ratesProvider.calculateCryptoAmount(_selectedAsset, etbAmount);
    });
  }

  Future<void> _proceedToPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final etbAmount = double.parse(_etbAmountController.text);
    
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Asset: $_selectedAsset'),
            Text('Amount: ${Formatters.formatETB(etbAmount)}'),
            Text('You will receive: ${Formatters.formatCrypto(_cryptoAmount, _selectedAsset)}'),
            Text('Payment: $_selectedPaymentMethod'),
            const SizedBox(height: 8),
            const Text(
              'Please review your order carefully before proceeding.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;

    // Create order
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final order = await ordersProvider.createOrder(
      asset: _selectedAsset,
      etbAmount: etbAmount,
      cryptoAmount: _cryptoAmount,
      paymentMethod: _selectedPaymentMethod,
      receiverAddress: _walletAddressController.text.trim(),
    );

    if (order != null) {
      if (!mounted) return;
      
      // Navigate to payment screen
      Navigator.of(context).pushNamed(
        '/payment',
        arguments: {
          'orderId': order.id,
          'paymentMethod': _selectedPaymentMethod,
          'etbAmount': etbAmount,
        },
      );
    } else {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ordersProvider.error ?? 'Failed to create order'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Crypto'),
      ),
      body: Consumer<RatesProvider>(
        builder: (context, ratesProvider, child) {
          if (ratesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Asset selection
                  const Text(
                    'Select Cryptocurrency',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  ...._assets.map((asset) {
                    final rate = ratesProvider.getRateBySymbol(asset['symbol']);
                    return Card(
                      color: _selectedAsset == asset['symbol']
                          ? AppTheme.primaryGreen.withOpacity(0.1)
                          : null,
                      child: RadioListTile<String>(
                        value: asset['symbol'],
                        groupValue: _selectedAsset,
                        onChanged: (value) {
                          setState(() {
                            _selectedAsset = value!;
                            _calculateCryptoAmount();
                          });
                        },
                        title: Row(
                          children: [
                            Icon(asset['icon'], color: AppTheme.primaryGreen),
                            const SizedBox(width: 12),
                            Text(
                              asset['name'],
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        subtitle: rate != null
                            ? Text('Rate: ${Formatters.formatETB(rate.etbPerUnit)}')
                            : const Text('Rate not available'),
                        activeColor: AppTheme.primaryGreen,
                      ),
                    );
                  }).toList(),
                  
                  const SizedBox(height: 24),
                  
                  // Amount input
                  const Text(
                    'Enter Amount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  TextFormField(
                    controller: _etbAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Amount in ETB',
                      hintText: 'Enter amount',
                      prefixIcon: Icon(Icons.money),
                      suffixText: 'ETB',
                    ),
                    validator: (value) => Validators.validateETBAmount(value, minAmount: 100),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Crypto amount display
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGreen.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'You will receive',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Formatters.formatCrypto(_cryptoAmount, _selectedAsset),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Payment method
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    decoration: const InputDecoration(
                      labelText: 'Select payment method',
                      prefixIcon: Icon(Icons.payment),
                    ),
                    items: _paymentMethods.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Wallet address
                  const Text(
                    'Wallet Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  TextFormField(
                    controller: _walletAddressController,
                    decoration: InputDecoration(
                      labelText: '$_selectedAsset Wallet Address',
                      hintText: 'Enter your wallet address',
                      prefixIcon: const Icon(Icons.account_balance_wallet),
                    ),
                    validator: (value) => Validators.validateWalletAddress(value, _selectedAsset),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.orange[700]),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Double-check your wallet address. Crypto sent to wrong address cannot be recovered.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Proceed button
                  Consumer<OrdersProvider>(
                    builder: (context, ordersProvider, child) {
                      if (ordersProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      
                      return ElevatedButton(
                        onPressed: _proceedToPayment,
                        child: const Text('Proceed to Payment'),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
