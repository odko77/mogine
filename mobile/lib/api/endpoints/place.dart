import 'package:mobile/api/api_response.dart';
import 'package:mobile/api/http.dart';
import 'package:mobile/models/place_state.dart';

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

  static Future<List<PlacePoint>> getPlaces() async {
    final res = await Http.get('/v1/map/point-name');

    final List data = res.data ?? [];
    return data.map((e) => PlacePoint.fromJson(e)).toList();
  }

  static Future<ApiResponse<Map<String, dynamic>>> deletePlace(
    String id,
  ) async {
    return Http.delete<Map<String, dynamic>>(
      '/v1/map/point-name/$id',
      parser: (raw) => (raw as Map).cast<String, dynamic>(),
    );
  }
}
