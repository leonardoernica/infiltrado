import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_input.dart';
import '../../providers/players_provider.dart';
import '../../providers/game_provider.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _addPlayer() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      ref.read(playersProvider.notifier).addPlayer(name);
      _controller.clear();
      HapticFeedback.lightImpact();
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);
    final isValid = players.length >= 4;

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Adicionar Jogadores', style: AppTextStyles.title.copyWith(fontSize: 20)),
            Text(
              '${players.length}/15 jogadores',
              style: AppTextStyles.caption.copyWith(
                color: players.length >= 4 ? AppColors.success : AppColors.error,
                fontWeight: players.length >= 4 ? FontWeight.normal : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Player List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: players.isEmpty ? 1 : players.length,
              itemBuilder: (context, index) {
                if (players.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(
                        children: [
                          Icon(Icons.group_add_rounded, size: 64, color: AppColors.textTertiary),
                          const SizedBox(height: 16),
                          Text(
                            'Adicione de 4 a 15 jogadores',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.error.withOpacity(0.3)),
                            ),
                            child: Text(
                              'Mínimo: 4 jogadores',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final player = players[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: ValueKey(player.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      ref.read(playersProvider.notifier).removePlayer(player.id);
                      HapticFeedback.selectionClick();
                    },
                    background: Container(
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(Icons.delete_outline, color: AppColors.error),
                    ),
                    child: AppCard(
                      color: AppColors.surface,
                      borderColor: AppColors.primaryLight,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                player.name[0].toUpperCase(),
                                style: AppTextStyles.heading.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              player.name,
                              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, size: 20, color: AppColors.textTertiary),
                            onPressed: () {
                              ref.read(playersProvider.notifier).removePlayer(player.id);
                              HapticFeedback.selectionClick();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppInput(
                    controller: _controller,
                    focusNode: _focusNode,
                    hintText: 'Nome do jogador',
                    suffixIcon: Icons.add_circle,
                    onSuffixTap: _addPlayer,
                    onSubmitted: (_) => _addPlayer(),
                  ),
                  if (players.length < 4 && players.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, 
                            color: AppColors.error, 
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Adicione pelo menos ${4 - players.length} jogador(es) para continuar',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'Continuar',
                      color: isValid ? AppColors.primary : AppColors.textTertiary.withOpacity(0.4),
                      onPressed: isValid
                          ? () {
                              ref.read(gameProvider.notifier).setPlayers(players);
                              context.push('/game_settings');
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
