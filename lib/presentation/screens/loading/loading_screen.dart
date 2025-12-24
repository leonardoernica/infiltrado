import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/game_provider.dart';
import '../../../domain/entities/game_state.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(gameProvider, (previous, next) {
      if (next.status == GameStatus.success) {
        context.go('/role_pass');
      } else if (next.status == GameStatus.error) {
        context.go('/categories');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Erro ao gerar palavras'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    // Handle case where it's already success when building
    final status = ref.watch(gameProvider.select((s) => s.status));
    if (status == GameStatus.success) {
      Future.microtask(() => context.go('/role_pass'));
    }
    if (status == GameStatus.error) {
      Future.microtask(() => context.go('/categories'));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                backgroundColor: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Gerando palavras...',
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
