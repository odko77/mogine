class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? info;
  final String? error;
  final String? warning;

  ApiResponse({
    required this.success,
    this.data,
    this.info,
    this.error,
    this.warning,
  });

  factory ApiResponse.fromJson(
    dynamic json, {
    T Function(dynamic raw)? parser,
  }) {
    if (json is! Map) {
      return ApiResponse<T>(success: false, error: 'Invalid response format');
    }

    final rawData = json['data'];

    return ApiResponse<T>(
      success: json['success'] == true,
      data: parser != null ? parser(rawData) : rawData as T?,
      info: json['info']?.toString(),
      error: json['error']?.toString(),
      warning: json['warning']?.toString(),
    );
  }
}
