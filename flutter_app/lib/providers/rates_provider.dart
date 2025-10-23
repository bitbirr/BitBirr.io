import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';
import '../models/crypto_rate.dart';

class RatesProvider with ChangeNotifier {
  List<CryptoRate> _rates = [];
  bool _isLoading = false;
  String? _error;

  List<CryptoRate> get rates => _rates;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRates() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await SupabaseService.client
          .from('rates')
          .select()
          .order('symbol');

      _rates = (response as List)
          .map((json) => CryptoRate.fromJson(json))
          .toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  CryptoRate? getRateBySymbol(String symbol) {
    try {
      return _rates.firstWhere((rate) => rate.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  double calculateCryptoAmount(String symbol, double etbAmount) {
    final rate = getRateBySymbol(symbol);
    if (rate == null) return 0;
    return etbAmount / rate.etbPerUnit;
  }

  double calculateETBAmount(String symbol, double cryptoAmount) {
    final rate = getRateBySymbol(symbol);
    if (rate == null) return 0;
    return cryptoAmount * rate.etbPerUnit;
  }
}
