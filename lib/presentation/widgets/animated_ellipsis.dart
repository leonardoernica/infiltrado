import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AnimatedEllipsis extends StatefulWidget {
  final TextStyle? style;
  final Duration duration;

  const AnimatedEllipsis({
    super.key,
    this.style,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<AnimatedEllipsis> createState() => _AnimatedEllipsisState();
}

class _AnimatedEllipsisState extends State<AnimatedEllipsis>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ??
        TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
        );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            // Stagger the animation for each dot
            final delay = index * 0.2;
            final animationValue = (_controller.value - delay) % 1.0;
            
            // Create a pulsing opacity effect
            final opacity = (animationValue < 0.5)
                ? 0.3 + (animationValue * 1.4)
                : 1.0 - ((animationValue - 0.5) * 1.4);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Opacity(
                opacity: opacity.clamp(0.3, 1.0),
                child: Text('.', style: textStyle),
              ),
            );
          }),
        );
      },
    );
  }
}
