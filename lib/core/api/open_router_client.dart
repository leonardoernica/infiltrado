import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../env/env_config.dart';

class OpenRouterClient {
  final Dio _dio;

  OpenRouterClient([Dio? dio]) : _dio = dio ?? Dio() {
    final apiKey = EnvConfig.openRouterApiKey;
    
    if (kDebugMode) {
      print('[OpenRouterClient] Initializing...');
      if (apiKey.isEmpty) {
        print('[OpenRouterClient] ⚠️ WARNING: API key is empty!');
      } else {
        print('[OpenRouterClient] ✅ API key configured (length: ${apiKey.length})');
      }
    }
    
    _dio.options.baseUrl = 'https://openrouter.ai/api/v1';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://github.com/com.infiltrado', 
      'X-Title': 'O Infiltrado',
    };
    
    if (kDebugMode) {
      print('[OpenRouterClient] Base URL: ${_dio.options.baseUrl}');
      print('[OpenRouterClient] Timeout: ${_dio.options.connectTimeout}');
    }
  }

  Dio get dio => _dio;
}
