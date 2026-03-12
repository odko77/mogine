import 'package:mobile/api/api_response.dart';
import 'package:mobile/api/http.dart';

class PlaceApi {
  PlaceApi._();

  static Future<ApiResponse<Map<String, dynamic>>> create(
    Map<String, dynamic> body,
  ) {
    return Http.post<Map<String, dynamic>>(
      '/v1/map/point-name',
      body: body,
      parser: (raw) => (raw as Map).cast<String, dynamic>(),
    );
  }
}
