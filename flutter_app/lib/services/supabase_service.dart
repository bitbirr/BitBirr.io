import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase service configuration
/// 
/// Before running the app:
/// 1. Create a Supabase project at https://supabase.com
/// 2. Run the SQL schema from supabase_schema.sql in the SQL Editor
/// 3. Replace the constants below with your project URL and anon key
/// 4. Enable Email Auth in Authentication > Providers
class SupabaseService {
  // TODO: Replace with your Supabase project URL
  static const String supabaseUrl = 'https://your-project.supabase.co';
  
  // TODO: Replace with your Supabase anon/public key
  static const String supabaseAnonKey = 'your-anon-key-here';

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  /// Get the Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;

  /// Get the current user
  static User? get currentUser => client.auth.currentUser;

  /// Check if user is logged in
  static bool get isLoggedIn => currentUser != null;
}
