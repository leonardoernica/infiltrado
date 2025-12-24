import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }

  static String get openRouterApiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';
}
