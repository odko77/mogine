class AuthSession {
  final String? token;
  final Map<String, dynamic>? me;
  final bool initialized;

  const AuthSession({this.token, this.me, this.initialized = false});

  bool get isAuthenticated => token != null && token!.isNotEmpty && me != null;

  AuthSession copyWith({
    String? token,
    Map<String, dynamic>? me,
    bool? initialized,
    bool clearToken = false,
    bool clearMe = false,
  }) {
    return AuthSession(
      token: clearToken ? null : (token ?? this.token),
      me: clearMe ? null : (me ?? this.me),
      initialized: initialized ?? this.initialized,
    );
  }
}
