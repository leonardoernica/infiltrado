import 'package:dio/dio.dart';
import '../env/env_config.dart';

class OpenRouterClient {
  final Dio _dio;

  OpenRouterClient([Dio? dio]) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = 'https://openrouter.ai/api/v1';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Authorization': 'Bearer ${EnvConfig.openRouterApiKey}',
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://github.com/com.infiltrado', 
      'X-Title': 'O Infiltrado',
    };
  }

  Dio get dio => _dio;
}
