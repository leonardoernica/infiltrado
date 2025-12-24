import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../providers/game_provider.dart';
import '../../../domain/entities/game_phase.dart';
import '../../../domain/entities/player.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Start discussion timer when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameProvider.notifier).startDiscussion();
    });
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);
    
    final secondsRemaining = gameState.secondsRemaining;
    final isTimerPaused = gameState.isTimerPaused;

    // Auto-navigate when phase changes
    ref.listen(gameProvider, (previous, next) {
      if (next.phase == GamePhase.voting) {
        context.go('/voting');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Discussão', style: AppTextStyles.title.copyWith(fontSize: 20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Timer CircularProgressIndicator
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: secondsRemaining / gameState.discussionDuration,
                        strokeWidth: 8,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          secondsRemaining > (gameState.discussionDuration * 0.33) ? AppColors.primary : AppColors.error,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatTime(secondsRemaining),
                          style: AppTextStyles.display.copyWith(fontSize: 40),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isTimerPaused ? 'PAUSADO' : 'Discussão',
                          style: AppTextStyles.caption.copyWith(
                            color: isTimerPaused ? AppColors.error : AppColors.textSecondary,
                            fontWeight: isTimerPaused ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Player Count
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.groups_rounded, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      '${gameState.players.where((p) => p.status == PlayerStatus.alive).length} jogadores ativos',
                      style: AppTextStyles.heading.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Control Buttons
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: isTimerPaused ? 'Continuar Contagem' : 'Pausar Discussão',
                  color: isTimerPaused ? AppColors.primary : AppColors.secondary,
                  icon: isTimerPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  onPressed: () {
                    if (isTimerPaused) {
                      notifier.resumeTimer();
                    } else {
                      notifier.pauseTimer();
                    }
                  },
                ),
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Ir para Votação',
                  icon: Icons.how_to_vote_rounded,
                  onPressed: () => notifier.goToVoting(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
