import 'package:mobile/api/http.dart';
import 'package:mobile/api/api_response.dart';

class UserApi {
  UserApi._();

  static Future<ApiResponse<Map<String, dynamic>>> me() {
    return Http.get<Map<String, dynamic>>(
      '/v1/auth/me',
      parser: (raw) => (raw as Map).cast<String, dynamic>(),
    );
  }
}
