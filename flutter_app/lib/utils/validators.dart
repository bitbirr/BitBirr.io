class Validators {
  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  /// Validate ETB amount
  static String? validateETBAmount(String? value, {double? minAmount}) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    if (minAmount != null && amount < minAmount) {
      return 'Minimum amount is ETB $minAmount';
    }

    return null;
  }

  /// Validate wallet address
  static String? validateWalletAddress(String? value, String asset) {
    if (value == null || value.isEmpty) {
      return 'Wallet address is required';
    }

    // Basic validation - check minimum length
    if (value.length < 26) {
      return 'Please enter a valid wallet address';
    }

    // BTC address validation (basic)
    if (asset == 'BTC') {
      if (!value.startsWith('1') && 
          !value.startsWith('3') && 
          !value.startsWith('bc1')) {
        return 'Invalid Bitcoin address';
      }
    }

    // ETH address validation (basic)
    if (asset == 'ETH') {
      if (!value.startsWith('0x') || value.length != 42) {
        return 'Invalid Ethereum address';
      }
    }

    // USDT (using ERC-20) address validation
    if (asset == 'USDT') {
      if (!value.startsWith('0x') || value.length != 42) {
        return 'Invalid USDT address';
      }
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
