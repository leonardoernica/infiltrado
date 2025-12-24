import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../providers/game_provider.dart';
import '../../../domain/entities/game_state.dart';

class CategorySelectionScreen extends ConsumerWidget {
  const CategorySelectionScreen({super.key});

  static const categories = [
    {'name': 'Cinema', 'icon': Icons.movie_outlined, 'color': Color(0xFFFFB4A2)},
    {'name': 'Comida', 'icon': Icons.restaurant_outlined, 'color': Color(0xFFFFD97D)},
    {'name': 'Animais', 'icon': Icons.pets_outlined, 'color': Color(0xFF95D5B2)},
    {'name': 'Lugares', 'icon': Icons.map_outlined, 'color': Color(0xFF7FB3D5)},
    {'name': 'História', 'icon': Icons.museum_outlined, 'color': Color(0xFFB4A7D6)},
    {'name': 'Esportes', 'icon': Icons.sports_soccer_outlined, 'color': Color(0xFFA5D8DD)},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Escolha a Categoria', style: AppTextStyles.title.copyWith(fontSize: 20)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final color = cat['color'] as Color;
          
          return AppCard(
            padding: EdgeInsets.zero,
            borderColor: color.withOpacity(0.3),
            onTap: () {
              HapticFeedback.lightImpact();
              ref.read(gameProvider.notifier).startGame(cat['name'] as String);
              context.go('/loading');
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      cat['icon'] as IconData,
                      size: 28,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    cat['name'] as String,
                    style: AppTextStyles.heading.copyWith(fontSize: 15),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
