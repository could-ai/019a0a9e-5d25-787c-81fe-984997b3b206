import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  static final LocalAuthentication _auth = LocalAuthentication();
  static bool _isAuthenticated = false;

  static bool get isAuthenticated => _isAuthenticated;

  static Future<void> initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('is_authenticated') ?? false;
  }

  static Future<bool> authenticate() async {
    try {
      final canAuthenticate = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      if (canAuthenticate) {
        _isAuthenticated = await _auth.authenticate(
          localizedReason: 'Please authenticate to access Smart Note',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
      } else {
        // Fallback to PIN (simple text input for demo)
        // In a real app, implement PIN logic
        _isAuthenticated = true; // Placeholder
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_authenticated', _isAuthenticated);
      return _isAuthenticated;
    } catch (e) {
      return false;
    }
  }
}
