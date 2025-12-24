import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../providers/game_provider.dart';
import '../../../domain/entities/player.dart';

class VotingScreen extends ConsumerStatefulWidget {
  const VotingScreen({super.key});

  @override
  ConsumerState<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends ConsumerState<VotingScreen> {
  String? _selectedVote;

  void _castVote() {
    if (_selectedVote == null) return;
    
    final notifier = ref.read(gameProvider.notifier);
    
    // Get the current player who is voting
    final currentPlayer = notifier.currentPlayer;
    if (currentPlayer == null) return;
    
    // Only cast vote for the current player
    notifier.castVote(currentPlayer.id, _selectedVote!);
    
    // Move to next player's turn
    notifier.nextTurn();
    
    // Check if all alive players have voted
    if (notifier.allVotesCast) {
      notifier.processVotes();
      context.go('/vote_result');
    } else {
      // Reset selection for next player
      setState(() => _selectedVote = null);
      // Stay on voting screen for next player
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);
    final currentPlayer = notifier.currentPlayer;
    // Filter out eliminated players and the current player (can't vote for yourself)
    final alivePlayers = gameState.players
        .where((p) => p.status == PlayerStatus.alive && (currentPlayer == null || p.id != currentPlayer.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Votação', style: AppTextStyles.title.copyWith(fontSize: 20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.how_to_vote_rounded, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (currentPlayer != null)
                            Text(
                              '${currentPlayer.name}, vote em quem você acha que é o infiltrado',
                              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                            )
                          else
                            Text(
                              'Vote em quem você acha que é o infiltrado',
                              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: alivePlayers.length,
                itemBuilder: (context, index) {
                  final player = alivePlayers[index];
                  final isSelected = _selectedVote == player.id;
                  
                  return AppCard(
                    padding: EdgeInsets.zero,
                    color: isSelected ? AppColors.primaryLight : AppColors.surface,
                    borderColor: isSelected ? AppColors.primary : AppColors.border,
                    onTap: () {
                      setState(() => _selectedVote = player.id);
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? AppColors.primary.withOpacity(0.2)
                                  : AppColors.surfaceElevated,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                player.name[0].toUpperCase(),
                                style: AppTextStyles.display.copyWith(
                                  fontSize: 24,
                                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            player.name,
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 14,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (isSelected) ...[
                            const SizedBox(height: 4),
                            Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Confirmar Voto',
                  color: _selectedVote != null ? AppColors.primary : AppColors.textTertiary.withOpacity(0.4),
                  icon: Icons.check_rounded,
                  onPressed: _selectedVote != null ? _castVote : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
