import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends AsyncNotifier<bool> {
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyToken = 'auth_token';

  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString(_keyToken);

    // token байвал logged in гэж үзнэ
    final isLoggedIn = token != null && token.isNotEmpty;

    return isLoggedIn;
  }

  /// Login үед token хадгална
  Future<void> login(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyToken, token);
    await prefs.setBool(_keyIsLoggedIn, true);

    state = const AsyncData(true);
  }

  /// Logout үед token устгана
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_keyToken);
    await prefs.setBool(_keyIsLoggedIn, false);

    state = const AsyncData(false);
  }

  /// Token авах helper
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, bool>(
  AuthNotifier.new,
);
