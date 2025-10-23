import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/supabase_service.dart';
import 'providers/auth_provider.dart';
import 'providers/rates_provider.dart';
import 'providers/orders_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/buy_crypto_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/order_details_screen.dart';
import 'screens/support_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService.initialize();
  
  runApp(const BitBirrApp());
}

class BitBirrApp extends StatelessWidget {
  const BitBirrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RatesProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: MaterialApp(
        title: 'BitBirr',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => const SplashScreen(),
                settings: settings,
              );
            case '/login':
              return MaterialPageRoute(
                builder: (_) => const LoginScreen(),
                settings: settings,
              );
            case '/home':
              return MaterialPageRoute(
                builder: (_) => const HomeScreen(),
                settings: settings,
              );
            case '/buy':
              return MaterialPageRoute(
                builder: (_) => const BuyCryptoScreen(),
                settings: settings,
              );
            case '/payment':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => PaymentScreen(
                  orderId: args['orderId'] as String,
                  paymentMethod: args['paymentMethod'] as String,
                  etbAmount: args['etbAmount'] as double,
                ),
                settings: settings,
              );
            case '/orders':
              return MaterialPageRoute(
                builder: (_) => const OrdersScreen(),
                settings: settings,
              );
            case '/order-details':
              final orderId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => OrderDetailsScreen(orderId: orderId),
                settings: settings,
              );
            case '/support':
              return MaterialPageRoute(
                builder: (_) => const SupportScreen(),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (_) => const SplashScreen(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}
