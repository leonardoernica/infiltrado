import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/game_provider.dart';
import '../../../domain/entities/game_state.dart';
import '../../widgets/animated_ellipsis.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen>
    with TickerProviderStateMixin {
  int _currentMessageIndex = 0;
  Timer? _messageTimer;
  late AnimationController _rotationController;
  late AnimationController _scaleController;

  final List<Map<String, dynamic>> _loadingMessages = [
    {
      'text': 'Escolhendo as palavras perfeitas',
      'icon': Icons.auto_awesome_outlined,
    },
    {
      'text': 'Criando a dica ideal para o infiltrado',
      'icon': Icons.lightbulb_outline,
    },
    {
      'text': 'Ajustando o nível de dificuldade',
      'icon': Icons.tune_outlined,
    },
    {
      'text': 'Preparando uma rodada inesquecível',
      'icon': Icons.celebration_outlined,
    },
    {
      'text': 'Garantindo que tudo está perfeito',
      'icon': Icons.verified_outlined,
    },
    {
      'text': 'Polindo os detalhes finais',
      'icon': Icons.diamond_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Rotation animation for the icon
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Scale animation for message transitions
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1.0,
    );

    // Rotate messages every 2.5 seconds
    _messageTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (mounted) {
        _scaleController.forward(from: 0.0);
        setState(() {
          _currentMessageIndex = (_currentMessageIndex + 1) % _loadingMessages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(gameProvider, (previous, next) {
      if (next.status == GameStatus.success) {
        context.go('/role_pass');
      } else if (next.status == GameStatus.error) {
        context.go('/categories');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Erro ao gerar palavras'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    // Handle case where it's already success when building
    final status = ref.watch(gameProvider.select((s) => s.status));
    if (status == GameStatus.success) {
      Future.microtask(() => context.go('/role_pass'));
    }
    if (status == GameStatus.error) {
      Future.microtask(() => context.go('/categories'));
    }

    final currentMessage = _loadingMessages[_currentMessageIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon with rotation and glow
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationController.value * 2 * math.pi,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.3),
                          AppColors.primary.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.psychology_outlined,
                          size: 32,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            // Progress indicator with gradient effect
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                backgroundColor: AppColors.primaryLight.withOpacity(0.3),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Animated message with icon
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                    ),
                    child: child,
                  ),
                );
              },
              child: Column(
                key: ValueKey<int>(_currentMessageIndex),
                children: [
                  Icon(
                    currentMessage['icon'] as IconData,
                    size: 24,
                    color: AppColors.primary.withOpacity(0.7),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          currentMessage['text'] as String,
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedEllipsis(
                        style: AppTextStyles.body.copyWith(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Subtle hint text
            Text(
              'Isso pode levar alguns segundos',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
