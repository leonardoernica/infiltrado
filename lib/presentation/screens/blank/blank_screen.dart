import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';

class BlankScreen extends ConsumerWidget {
  const BlankScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              Icon(
                Icons.visibility_off_outlined,
                size: 64,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 24),
              Text(
                'Passe o dispositivo',
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'para o próximo jogador',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Pronto',
                  onPressed: () => context.push('/role_pass'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
