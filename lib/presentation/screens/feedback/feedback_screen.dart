import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../../data/services/game_log_service.dart';
import '../../providers/game_provider.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  bool? _civilianFeedback;
  bool? _infiltratorFeedback;
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;
  List<String> _logFilePaths = [];

  @override
  void initState() {
    super.initState();
    _loadLogFilePaths();
  }

  Future<void> _loadLogFilePaths() async {
    final logService = GameLogService();
    final paths = await logService.getAllLogFilePaths();
    setState(() => _logFilePaths = paths);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_civilianFeedback == null || _infiltratorFeedback == null) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, avalie ambas as palavras'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final logService = GameLogService();
      final recentEntry = await logService.getMostRecentEntry();

      if (recentEntry != null) {
        await logService.updateFeedback(
          recentEntry.id,
          civilianFeedback: _civilianFeedback,
          infiltratorFeedback: _infiltratorFeedback,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );
      }

      // Navigate back to result screen
      if (mounted) {
        context.go('/result');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar feedback: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordPair = ref.watch(gameProvider.select((s) => s.currentWordPair));

    if (wordPair == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:
            Text('Feedback', style: AppTextStyles.title.copyWith(fontSize: 20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ajude a melhorar o jogo!',
                style: AppTextStyles.title.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                'Avalie se as palavras fizeram sentido para esta rodada',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

              // Civilian word feedback
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.people_outline,
                            color: AppColors.primary, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Palavra Principal',
                            style: AppTextStyles.heading.copyWith(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        wordPair.civilian,
                        style: AppTextStyles.title.copyWith(
                          fontSize: 20,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Esta palavra fez sentido para a categoria?',
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _FeedbackButton(
                            text: 'Sim',
                            icon: Icons.thumb_up,
                            isSelected: _civilianFeedback == true,
                            color: AppColors.success,
                            onTap: () {
                              setState(() => _civilianFeedback = true);
                              HapticFeedback.lightImpact();
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FeedbackButton(
                            text: 'Não',
                            icon: Icons.thumb_down,
                            isSelected: _civilianFeedback == false,
                            color: AppColors.error,
                            onTap: () {
                              setState(() => _civilianFeedback = false);
                              HapticFeedback.lightImpact();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Infiltrator word feedback
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.visibility_off_outlined,
                            color: AppColors.secondary, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Dica do Infiltrado',
                            style: AppTextStyles.heading.copyWith(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        wordPair.infiltrator,
                        style: AppTextStyles.title.copyWith(
                          fontSize: 20,
                          color: AppColors.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'A conexão com a palavra principal fez sentido?',
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _FeedbackButton(
                            text: 'Sim',
                            icon: Icons.thumb_up,
                            isSelected: _infiltratorFeedback == true,
                            color: AppColors.success,
                            onTap: () {
                              setState(() => _infiltratorFeedback = true);
                              HapticFeedback.lightImpact();
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FeedbackButton(
                            text: 'Não',
                            icon: Icons.thumb_down,
                            isSelected: _infiltratorFeedback == false,
                            color: AppColors.error,
                            onTap: () {
                              setState(() => _infiltratorFeedback = false);
                              HapticFeedback.lightImpact();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Notes
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Observações (opcional)',
                      style: AppTextStyles.heading.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      style: AppTextStyles.body
                          .copyWith(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText:
                            'Ex: A dica foi muito óbvia, ou não fez sentido...',
                        hintStyle: AppTextStyles.body
                            .copyWith(color: AppColors.textTertiary),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),

              // Log file paths info (for debugging)
              if (_logFilePaths.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.border.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 16, color: AppColors.textTertiary),
                          const SizedBox(width: 8),
                          Text(
                            'Arquivos de Log',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._logFilePaths.asMap().entries.map((entry) {
                        final index = entry.key;
                        final path = entry.value;
                        final isProjectPath = path.contains('/logs/');

                        return Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  index < _logFilePaths.length - 1 ? 12 : 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isProjectPath
                                        ? Icons.folder
                                        : Icons.phone_android,
                                    size: 14,
                                    color: isProjectPath
                                        ? AppColors.success
                                        : AppColors.textTertiary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isProjectPath
                                        ? 'Projeto (Desktop)'
                                        : 'App (Mobile)',
                                    style: AppTextStyles.caption.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isProjectPath
                                          ? AppColors.success
                                          : AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                path,
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 11,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: path));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Caminho ${isProjectPath ? "do projeto" : "do app"} copiado'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.copy,
                                          size: 12, color: AppColors.primary),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Copiar',
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.primary,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton.icon(
                          onPressed: () async {
                            try {
                              await GameLogService().shareLogFile();
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erro ao compartilhar logs: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icon(Icons.share, size: 16, color: AppColors.primary),
                          label: Text(
                            'Compartilhar/Exportar Logs',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton.icon(
                          onPressed: () async {
                            try {
                              final content = await GameLogService().exportLogsAsJson();
                              await Clipboard.setData(ClipboardData(text: content));
                              
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Logs copiados para a área de transferência!'),
                                    backgroundColor: AppColors.success,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erro ao copiar logs: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icon(Icons.copy, size: 16, color: AppColors.textSecondary),
                          label: Text(
                            'Copiar JSON para Clipboard',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: _isLoading ? 'Salvando...' : 'Enviar Feedback',
                  icon: Icons.send_rounded,
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _submitFeedback,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FeedbackButton({
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: isSelected ? color : AppColors.surface,
      borderColor: isSelected ? color : AppColors.border,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.button.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
