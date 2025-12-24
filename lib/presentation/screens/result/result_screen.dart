import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../providers/game_provider.dart';
import '../../../domain/entities/player.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);

    final winner = notifier.getWinner();
    final isCiviliansWin = winner == 'civilians';

    final infiltrator = gameState.players.firstWhere(
      (p) => p.role == PlayerRole.infiltrator,
      orElse: () => gameState.players.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              Icon(
                isCiviliansWin
                    ? Icons.emoji_events_rounded
                    : Icons.vape_free_rounded,
                size: 100,
                color: isCiviliansWin ? AppColors.primary : AppColors.error,
              ),
              const SizedBox(height: 32),

              Text(
                isCiviliansWin ? 'Vitória dos Civis!' : 'O Infiltrado Venceu!',
                style: AppTextStyles.display.copyWith(
                  color: isCiviliansWin ? AppColors.primary : AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                isCiviliansWin
                    ? 'O infiltrado foi descoberto e eliminado.'
                    : 'O infiltrado conseguiu enganar a todos.',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Text(
                      'O INFILTRADO ERA',
                      style: AppTextStyles.caption.copyWith(letterSpacing: 2),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      infiltrator.name.toUpperCase(),
                      style: AppTextStyles.title
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Feedback Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Avaliar Palavras',
                  color: AppColors.secondary,
                  icon: Icons.feedback_outlined,
                  onPressed: () {
                    context.go('/feedback');
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Nova Rodada
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Nova Rodada',
                  icon: Icons.refresh_rounded,
                  onPressed: () {
                    notifier.newRound();
                    context.go('/loading');
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Nova Categoria
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Trocar Categoria',
                  color: AppColors.secondary,
                  icon: Icons.category_outlined,
                  onPressed: () {
                    notifier.resetForNewCategory();
                    context.go('/categories');
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Editar Jogadores
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Editar Jogadores',
                  color: AppColors.secondary,
                  icon: Icons.person_add_alt_outlined,
                  onPressed: () {
                    notifier.resetForPlayerEdit();
                    context.go('/setup');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
