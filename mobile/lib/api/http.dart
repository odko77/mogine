import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_response.dart';

class Http {
  Http._();

  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: 'http://192.168.1.2:5000/api',
            // baseUrl: 'http://192.168.161.68:5000/api',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept-Encoding': 'gzip',
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('auth_token');

              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }

              handler.next(options);
            },
          ),
        );

  /// ---------------- POST ----------------
  static Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    T Function(dynamic raw)? parser,
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
      final data = e.response?.data;

      if (data is Map) {
        return ApiResponse<T>.fromJson(data, parser: parser);
      }

      return ApiResponse<T>(success: false, error: _dioToText(e));
    } catch (_) {
      return ApiResponse<T>(success: false, error: 'Түр алдаа гарлаа');
    }
  }

  /// ---------------- MULTIPART POST ----------------
  static Future<ApiResponse<T>> postMultipart<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    File? file,
    String fileKey = 'file',
    T Function(dynamic raw)? parser,
    Options? options,
  }) async {
    try {
      final formMap = <String, dynamic>{};

      if (body != null) {
        formMap.addAll(body);
      }

      if (file != null) {
        final fileName = file.path.split('/').last;

        formMap[fileKey] = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(formMap);

      final res = await dio.post(
        path,
        data: formData,
        queryParameters: query,
        options: (options ?? Options()).copyWith(
          contentType: 'multipart/form-data',
        ),
      );

      return ApiResponse<T>.fromJson(res.data, parser: parser);
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map) {
        return ApiResponse<T>.fromJson(data, parser: parser);
      }

      return ApiResponse<T>(success: false, error: _dioToText(e));
    } catch (e) {
      return ApiResponse<T>(success: false, error: 'Түр алдаа гарлаа: $e');
    }
  }

  /// ---------------- GET ----------------
  static Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic raw)? parser,
    Options? options,
  }) async {
    try {
      final res = await dio.get(path, queryParameters: query, options: options);

      return ApiResponse<T>.fromJson(res.data, parser: parser);
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map) {
        return ApiResponse<T>.fromJson(data, parser: parser);
      }

      return ApiResponse<T>(success: false, error: _dioToText(e));
    } catch (_) {
      return ApiResponse<T>(success: false, error: 'Түр алдаа гарлаа');
    }
  }

  /// ---------------- DELETE ----------------
  static Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    T Function(dynamic raw)? parser,
    Options? options,
  }) async {
    try {
      final res = await dio.delete(
        path,
        data: body,
        queryParameters: query,
        options: options,
      );

      return ApiResponse<T>.fromJson(res.data, parser: parser);
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map) {
        return ApiResponse<T>.fromJson(data, parser: parser);
      }

      return ApiResponse<T>(success: false, error: _dioToText(e));
    } catch (_) {
      return ApiResponse<T>(success: false, error: 'Түр алдаа гарлаа');
    }
  }

  /// ---------------- Error handler ----------------
  static String _dioToText(DioException e) {
    print("Dio error $e");

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
