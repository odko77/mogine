import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/api/endpoints/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/models/auth_session.dart';

class AuthNotifier extends AsyncNotifier<AuthSession> {
  static const _keyToken = 'auth_token';

  @override
  Future<AuthSession> build() async {
    return _initialize();
  }

  Future<AuthSession> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);

    if (token == null || token.isEmpty) {
      return const AuthSession(initialized: true);
    }

    final meRes = await UserApi.me();

    if (!meRes.success || meRes.data == null) {
      await prefs.remove(_keyToken);
      return const AuthSession(initialized: true);
    }

    return AuthSession(token: token, me: meRes.data, initialized: true);
  }

  Future<bool> login(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyToken, token);

    final meRes = await UserApi.me();

    if (!meRes.success || meRes.data == null) {
      await prefs.remove(_keyToken);
      state = const AsyncData(AuthSession(initialized: true));
      return false;
    }

    state = AsyncData(
      AuthSession(token: token, me: meRes.data, initialized: true),
    );

    return true;
  }

  Future<void> refreshMe() async {
    final current = state.value;
    if (current == null || current.token == null || current.token!.isEmpty) {
      return;
    }

    final meRes = await UserApi.me();

    if (!meRes.success || meRes.data == null) {
      await logout();
      return;
    }

    state = AsyncData(current.copyWith(me: meRes.data, initialized: true));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);

    state = const AsyncData(AuthSession(initialized: true));
  }

  String? get token => state.value?.token;
  Map<String, dynamic>? get me => state.value?.me;
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthSession>(
  AuthNotifier.new,
);
