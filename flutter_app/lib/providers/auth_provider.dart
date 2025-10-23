import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/user_profile.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initialize();
  }

  void _initialize() {
    // Listen to auth state changes
    SupabaseService.client.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      if (_user != null) {
        _loadProfile();
      } else {
        _profile = null;
      }
      notifyListeners();
    });

    // Check current auth state
    _user = SupabaseService.currentUser;
    if (_user != null) {
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    try {
      final response = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', _user!.id)
          .single();
      
      _profile = UserProfile.fromJson(response);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  Future<bool> signInWithOTP(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await SupabaseService.client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: null,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOTP(String email, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await SupabaseService.client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
    _user = null;
    _profile = null;
    notifyListeners();
  }

  Future<bool> updateProfile(String fullName) async {
    if (_user == null) return false;

    try {
      await SupabaseService.client
          .from('profiles')
          .update({'full_name': fullName})
          .eq('id', _user!.id);
      
      await _loadProfile();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
