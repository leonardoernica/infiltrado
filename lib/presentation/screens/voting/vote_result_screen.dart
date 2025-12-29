import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../providers/game_provider.dart';
import '../../../domain/entities/player.dart';

class VoteResultScreen extends ConsumerWidget {
  const VoteResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);
    
    final eliminatedPlayer = gameState.players.firstWhere(
      (p) => p.status == PlayerStatus.eliminated,
      orElse: () => gameState.players.first,
    );
    
    final wasEliminated = gameState.players.any((p) => p.status == PlayerStatus.eliminated);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Resultado', style: AppTextStyles.title.copyWith(fontSize: 20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              if (wasEliminated) ...[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: eliminatedPlayer.role == PlayerRole.infiltrator 
                        ? AppColors.primary.withOpacity(0.1) 
                        : AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: eliminatedPlayer.role == PlayerRole.infiltrator 
                          ? AppColors.primary 
                          : AppColors.error,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      eliminatedPlayer.role == PlayerRole.infiltrator 
                          ? Icons.check_circle_outline 
                          : Icons.person_off_outlined,
                      size: 64,
                      color: eliminatedPlayer.role == PlayerRole.infiltrator 
                          ? AppColors.primary 
                          : AppColors.error,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '${eliminatedPlayer.name} foi eliminado!',
                  style: AppTextStyles.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  eliminatedPlayer.role == PlayerRole.infiltrator 
                      ? 'Ele era o Infiltrado!' 
                      : 'Ele era um Civil...',
                  style: AppTextStyles.body.copyWith(
                    color: eliminatedPlayer.role == PlayerRole.infiltrator 
                        ? AppColors.primary 
                        : AppColors.error,
                  ),
                ),
              ] else ...[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.warning,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.balance_rounded,
                      size: 64,
                      color: AppColors.warning,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Empate na Votação',
                  style: AppTextStyles.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'Ninguém foi eliminado nesta rodada.\nA discussão continua!',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  textAlign: TextAlign.center,
                  ),
                ),
              ],
              
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Continuar',
                  onPressed: () {
                    final winner = notifier.getWinner();
                    if (winner != null) {
                      notifier.applyGameOver();
                      context.go('/result');
                    } else {
                      // Resume timer from where it left off
                      notifier.resumeDiscussion();
                      context.go('/game');
                    }
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
