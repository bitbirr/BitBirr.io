import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';
import '../models/order.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await SupabaseService.client
          .from('orders')
          .select()
          .eq('user_id', SupabaseService.currentUser!.id)
          .order('created_at', ascending: false);

      _orders = (response as List)
          .map((json) => Order.fromJson(json))
          .toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Order?> createOrder({
    required String asset,
    required double etbAmount,
    required double cryptoAmount,
    required String paymentMethod,
    required String receiverAddress,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await SupabaseService.client
          .from('orders')
          .insert({
            'user_id': SupabaseService.currentUser!.id,
            'asset': asset,
            'etb_amount': etbAmount,
            'crypto_amount': cryptoAmount,
            'payment_method': paymentMethod,
            'receiver_address': receiverAddress,
            'status': 'pending',
          })
          .select()
          .single();

      final order = Order.fromJson(response);
      _orders.insert(0, order);
      
      _isLoading = false;
      notifyListeners();
      return order;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      await SupabaseService.client
          .from('orders')
          .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', orderId);
      
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        await fetchOrders(); // Refresh to get updated order
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }
}
