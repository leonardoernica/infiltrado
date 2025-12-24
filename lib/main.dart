import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/env/env_config.dart';
import 'core/api/open_router_client.dart';
import 'data/datasources/ai_word_datasource.dart';
import 'data/repositories/game_repository_impl.dart';
import 'presentation/providers/game_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  await EnvConfig.init();
  
  final dio = OpenRouterClient().dio;
  final aiDataSource = AiWordDatasource(OpenRouterClient(dio));
  final gameRepository = GameRepositoryImpl(aiDataSource);

  runApp(
    ProviderScope(
      overrides: [
        gameRepositoryImplProvider.overrideWithValue(gameRepository),
      ],
      child: const InfiltradoApp(),
    ),
  );
}

class InfiltradoApp extends ConsumerWidget {
  const InfiltradoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'O Infiltrado',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Wrap with GestureDetector to dismiss keyboard on tap outside
        return GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.opaque,
          child: child,
        );
      },
    );
  }
}
