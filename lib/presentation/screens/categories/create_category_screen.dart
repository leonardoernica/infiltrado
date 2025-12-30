import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import '../../providers/game_provider.dart';

class CreateCategoryScreen extends ConsumerStatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  ConsumerState<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends ConsumerState<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      
      ref.read(gameProvider.notifier).startGame(name, customDescription: description);
      context.go('/loading');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Criar Categoria', style: AppTextStyles.title.copyWith(fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Crie sua própria categoria para o jogo!',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              
              Text('Nome da Categoria', style: AppTextStyles.heading),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextFormField(
                  controller: _nameController,
                  style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Ex: Tecnologia, Mitologia, Anos 90...',
                    hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary.withOpacity(0.5)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira um nome.';
                    }
                    return null;
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text('Descrição Detalhada', style: AppTextStyles.heading),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Descreva o que essa categoria abrange. Quanto mais detalhes, melhor a IA entenderá.',
                    hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary.withOpacity(0.5)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 10) {
                      return 'A descrição deve ter pelo menos 10 caracteres.';
                    }
                    return null;
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Examples Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text('Exemplo de Boa Descrição', style: AppTextStyles.heading.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"Abrange o universo da tecnologia moderna, incluindo hardware, software, internet, gadgets, linguagens de programação, empresas tech, inovações, e cultura hacker."',
                      style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              AppButton(
                text: 'Criar e Jogar',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
