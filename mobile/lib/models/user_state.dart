class UserState {
  final String? token;
  final String? phone;
  final String? name;

  const UserState({this.token, this.phone, this.name});

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  UserState copyWith({
    String? token,
    String? phone,
    String? name,
    bool clearToken = false,
  }) {
    return UserState(
      token: clearToken ? null : (token ?? this.token),
      phone: phone ?? this.phone,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "phone": phone,
    "name": name,
  };

  factory UserState.fromJson(Map<String, dynamic> json) {
    return UserState(
      token: json["token"]?.toString(),
      phone: json["phone"]?.toString(),
      name: json["name"]?.toString(),
    );
  }
}
