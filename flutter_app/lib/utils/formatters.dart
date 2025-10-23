import 'package:intl/intl.dart';

class Formatters {
  /// Format currency in Ethiopian Birr
  static String formatETB(double amount) {
    final formatter = NumberFormat.currency(
      symbol: 'ETB ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Format cryptocurrency amount
  static String formatCrypto(double amount, String symbol) {
    int decimals = 8;
    if (symbol == 'BTC') {
      decimals = 8;
    } else if (symbol == 'ETH') {
      decimals = 6;
    } else if (symbol == 'USDT') {
      decimals = 2;
    }

    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimals,
    );
    return '${formatter.format(amount)} $symbol';
  }

  /// Format date and time
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('MMM dd, yyyy - hh:mm a');
    return formatter.format(dateTime);
  }

  /// Format date only
  static String formatDate(DateTime dateTime) {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(dateTime);
  }

  /// Format time only
  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }
}
