import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../providers/game_provider.dart';
import '../../../domain/entities/player.dart';

class RolePassScreen extends ConsumerStatefulWidget {
  const RolePassScreen({super.key});

  @override
  ConsumerState<RolePassScreen> createState() => _RolePassScreenState();
}

class _RolePassScreenState extends ConsumerState<RolePassScreen> {
  bool _isRevealed = false;

  void _onRevealStart() {
    setState(() => _isRevealed = true);
    final player = ref.read(gameProvider.notifier).currentPlayer;
    HapticFeedback.lightImpact();
  }

  void _onRevealEnd() {
    setState(() => _isRevealed = false);
  }
  
  void _nextPlayer() {
    final notifier = ref.read(gameProvider.notifier);
    notifier.nextTurn();
    if (notifier.isDistributionComplete) {
      // All players saw their roles, start game
      context.go('/game');
    } else {
      // Go to blank screen to hide next player's role
      context.go('/blank');
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);
    
    final player = notifier.currentPlayer;
    final wordPair = gameState.currentWordPair;

    if (player == null || wordPair == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isSpy = player.role == PlayerRole.infiltrator;
    final secretWord = isSpy ? wordPair.infiltrator : wordPair.civilian;
    final roleColor = isSpy ? AppColors.secondary : AppColors.success;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(player.name, style: AppTextStyles.title.copyWith(fontSize: 20)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              
              // Instruction
              if (!_isRevealed)
                Text(
                  'Toque e segure para revelar',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
              
              const SizedBox(height: 32),
              
              // Reveal Area
              GestureDetector(
                onTapDown: (_) => _onRevealStart(),
                onTapUp: (_) => _onRevealEnd(),
                onTapCancel: () => _onRevealEnd(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRevealed
                        ? roleColor.withOpacity(0.1)
                        : AppColors.surface,
                    border: Border.all(
                      color: _isRevealed ? roleColor : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: _isRevealed
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                secretWord.toUpperCase(),
                                style: AppTextStyles.display.copyWith(
                                  color: roleColor,
                                  fontSize: 28,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: roleColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isSpy ? 'Infiltrado' : 'Civil',
                                  style: AppTextStyles.caption.copyWith(
                                    color: roleColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Icon(
                            Icons.touch_app_outlined,
                            color: AppColors.textTertiary,
                            size: 64,
                          ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Next Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Memorizei',
                  onPressed: () {
                    _onRevealEnd();
                    _nextPlayer();
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
