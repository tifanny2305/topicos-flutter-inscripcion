import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  ApiClient._internal(this.dio);

  static final ApiClient _instance = ApiClient._create();

  factory ApiClient() => _instance;

  static ApiClient _create() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    // Add interceptors, auth headers, logging, etc.
    return ApiClient._internal(dio);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, dynamic data) async {
    return dio.post(path, data: data);
  }
}
