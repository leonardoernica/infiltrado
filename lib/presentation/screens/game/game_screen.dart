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

  void _showForgotWordDialog() {
    final gameState = ref.read(gameProvider);
    final alivePlayers = gameState.players.where((p) => p.status == PlayerStatus.alive).toList();

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Quem esqueceu?', textAlign: TextAlign.center),
        children: alivePlayers.map((player) {
          return SimpleDialogOption(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            onPressed: () {
              Navigator.pop(context); // Close selection dialog
              _showRevealDialog(player as Player);
            },
            child: Row(
              children: [
                Icon(Icons.person, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(player.name, style: AppTextStyles.body),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showRevealDialog(Player player) {
    bool isRevealed = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              isRevealed ? 'Palavra Secreta' : 'Atenção!',
              textAlign: TextAlign.center,
              style: AppTextStyles.title,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isRevealed) ...[
                  const Icon(Icons.lock_rounded, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'Passe o celular para:\n${player.name}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading,
                  ),
                ] else ...[
                  if (player.role == PlayerRole.infiltrator) ...[
                    const Icon(Icons.visibility_off_rounded, size: 64, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Você é o Infiltrado!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Disfarce e descubra a palavra.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body,
                    ),
                  ] else ...[
                    const Icon(Icons.visibility_rounded, size: 64, color: AppColors.secondary),
                    const SizedBox(height: 16),
                    Text(
                      'Sua palavra é:',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ref.read(gameProvider).currentWordPair?.civilian ?? 'Erro',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading.copyWith(color: AppColors.secondary, fontSize: 32),
                    ),
                  ]
                ],
              ],
            ),
            actions: [
              if (!isRevealed)
                AppButton(
                  text: 'Sou eu, mostrar',
                  onPressed: () {
                    setState(() => isRevealed = true);
                  },
                )
              else
                AppButton(
                  text: 'Entendi, ocultar',
                  onPressed: () => Navigator.pop(context),
                ),
            ],
          );
        },
      ),
    );
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

              const SizedBox(height: 12),
              
              TextButton.icon(
                onPressed: _showForgotWordDialog,
                icon: const Icon(Icons.help_outline_rounded, color: AppColors.textSecondary),
                label: Text(
                  'Esqueci minha palavra',
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
