import 'package:dio/dio.dart';
import 'api_response.dart';

class Http {
  Http._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.161.68:5000/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Axios шиг: Http.post("/path", body: {...})
  static Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    T Function(dynamic raw)? parser, // хүсвэл data-г model болгож парсална
    Options? options,
  }) async {
    try {
      final res = await dio.post(
        path,
        data: body,
        queryParameters: query,
        options: options,
      );
      return ApiResponse<T>.fromJson(res.data, parser: parser);
    } on DioException catch (e) {
      // Танай backend error-оо энэ бүтэцтэй буцаадаг бол түүнийг шууд задлаад өгнө
      final data = e.response?.data;
      if (data is Map) {
        return ApiResponse<T>.fromJson(data, parser: parser);
      }
      return ApiResponse<T>(success: false, error: _dioToText(e));
    } catch (_) {
      return ApiResponse<T>(success: false, error: 'Түр алдаа гарлаа');
    }
  }

  static String _dioToText(DioException e) {
    print("Dio error ${e}");
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Сүлжээ удаан байна. Дахин оролдоно уу';
      case DioExceptionType.badResponse:
        return 'Серверийн алдаа (${e.response?.statusCode ?? "-"})';
      default:
        return 'Холболтын алдаа';
    }
  }
}
