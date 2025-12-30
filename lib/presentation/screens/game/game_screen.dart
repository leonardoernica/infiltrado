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
  }

  void _showForgotWordDialog() {
    final gameState = ref.read(gameProvider);
    final alivePlayers = gameState.players.where((p) => p.status == PlayerStatus.alive).toList();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Quem esqueceu?',
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: alivePlayers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final player = alivePlayers[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      tileColor: AppColors.surfaceElevated,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: Text(
                          player.name[0].toUpperCase(),
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(player.name, style: AppTextStyles.heading.copyWith(fontSize: 16)),
                      trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                      onTap: () {
                        Navigator.pop(context); // Close selection dialog
                        _showRevealDialog(player as Player);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
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
          final isSpy = player.role == PlayerRole.infiltrator;
          final roleColor = isSpy ? AppColors.primary : AppColors.secondary;
          
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isRevealed ? roleColor.withOpacity(0.5) : AppColors.border,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isRevealed ? roleColor : Colors.black).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isRevealed) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_person_rounded, size: 80, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Passe o celular para:',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      player.name,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.display.copyWith(fontSize: 36),
                    ),
                    const SizedBox(height: 40),
                    AppButton(
                      text: 'Sou eu, mostrar',
                      onPressed: () {
                        setState(() => isRevealed = true);
                      },
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: roleColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSpy ? Icons.visibility_off_rounded : Icons.person_rounded, 
                        size: 80, 
                        color: roleColor
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: roleColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        isSpy ? 'INFILTRADO' : 'CIVIL',
                        style: AppTextStyles.caption.copyWith(
                          color: roleColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (!isSpy) ...[
                      Text(
                        'Sua palavra secreta é:',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        ref.read(gameProvider).currentWordPair?.civilian ?? 'Erro',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.display.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Você deve se disfarçar e tentar descobrir a palavra dos civis!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(fontSize: 18),
                      ),
                    ],
                    const SizedBox(height: 48),
                    AppButton(
                      text: 'Entendi, ocultar',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ],
              ),
            ),
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
