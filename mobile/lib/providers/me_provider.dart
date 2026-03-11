import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/api/endpoints/user.dart';
import 'package:mobile/providers/auth_provider.dart';

final meProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final session = ref.watch(authProvider).value;
  final loggedIn = session?.isAuthenticated ?? false;

  if (!loggedIn) return null;

  final res = await UserApi.me();

  if (!res.success || res.data == null) {
    throw Exception(res.error ?? 'Failed to load profile');
  }

  return res.data;
});
