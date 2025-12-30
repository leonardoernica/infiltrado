import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class EnvConfig {
  static Future<void> init() async {
    try {
      await dotenv.load(fileName: ".env");
      if (kDebugMode) {
        print('[EnvConfig] .env file loaded successfully');
        final apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';
        if (apiKey.isEmpty) {
          print('[EnvConfig] ⚠️ WARNING: OPENROUTER_API_KEY is empty or not found!');
        } else {
          print('[EnvConfig] ✅ OPENROUTER_API_KEY is present (length: ${apiKey.length})');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('[EnvConfig] ❌ ERROR loading .env file: $e');
      }
      rethrow;
    }
  }

  static String get openRouterApiKey {
    final key = dotenv.env['OPENROUTER_API_KEY'] ?? '';
    if (kDebugMode && key.isEmpty) {
      print('[EnvConfig] ⚠️ API key requested but is empty!');
    }
    return key;
  }
}
