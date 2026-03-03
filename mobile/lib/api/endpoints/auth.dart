import 'package:mobile/api/api_response.dart';
import 'package:mobile/api/http.dart';

class AuthApi {
  AuthApi._();

  static Future<ApiResponse<Map<String, dynamic>>> login(
    Map<String, dynamic> body,
  ) {
    return Http.post<Map<String, dynamic>>(
      '/v1/auth/login',
      body: body,
      parser: (raw) => (raw as Map).cast<String, dynamic>(),
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> verifyOtp(
    Map<String, dynamic> body,
  ) {
    return Http.post<Map<String, dynamic>>(
      '/v1/auth/verify',
      body: body,
      parser: (raw) => (raw as Map).cast<String, dynamic>(),
    );
  }
}
