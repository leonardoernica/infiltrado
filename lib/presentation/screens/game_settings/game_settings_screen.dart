import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../providers/game_provider.dart';

class GameSettingsScreen extends ConsumerStatefulWidget {
  const GameSettingsScreen({super.key});

  @override
  ConsumerState<GameSettingsScreen> createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends ConsumerState<GameSettingsScreen> {
  int _selectedDuration = 180; // 3 minutes default
  int _selectedInfiltratorCount = 1;

  final List<int> _durations = [120, 180, 300, 600]; // 2, 3, 5, 10 minutes

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final playerCount = gameState.players.length;
    
    // Calculate max infiltrators based on player count
    final maxInfiltrators = (playerCount / 3).floor().clamp(1, 3);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Configurações do Jogo', style: AppTextStyles.title.copyWith(fontSize: 20)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Player count info
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
                      '$playerCount jogadores',
                      style: AppTextStyles.heading.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Duration Selection
              Text(
                'Tempo de Discussão',
                style: AppTextStyles.heading.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Row(
                children: _durations.map((duration) {
                  final minutes = duration ~/ 60;
                  final isSelected = _selectedDuration == duration;
                  
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderColor: isSelected ? AppColors.primary : AppColors.border,
                        onTap: () {
                          setState(() => _selectedDuration = duration);
                          HapticFeedback.lightImpact();
                        },
                        child: Column(
                          children: [
                            Text(
                              '$minutes',
                              style: AppTextStyles.title.copyWith(
                                fontSize: 24,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'min',
                              style: AppTextStyles.caption.copyWith(
                                color: isSelected ? Colors.white.withOpacity(0.9) : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 32),
              
              // Infiltrator Count Selection
              Text(
                'Quantidade de Infiltrados',
                style: AppTextStyles.heading.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                'Máximo: $maxInfiltrators (baseado no número de jogadores)',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: List.generate(maxInfiltrators, (index) {
                  final count = index + 1;
                  final isSelected = _selectedInfiltratorCount == count;
                  
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        color: isSelected ? AppColors.secondary : AppColors.surface,
                        borderColor: isSelected ? AppColors.secondary : AppColors.border,
                        onTap: () {
                          setState(() => _selectedInfiltratorCount = count);
                          HapticFeedback.lightImpact();
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 32,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$count',
                              style: AppTextStyles.title.copyWith(
                                fontSize: 24,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 32),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Continuar',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    // Set game settings
                    ref.read(gameProvider.notifier).setGameSettings(
                      discussionDuration: _selectedDuration,
                      infiltratorCount: _selectedInfiltratorCount,
                    );
                    context.go('/categories');
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


