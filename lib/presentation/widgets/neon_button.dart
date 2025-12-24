import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final bool fullWidth;

  const NeonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? AppColors.neonLime;
    
    return Container(
      width: fullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: btnColor.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: -5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          text.toUpperCase(),
          style: AppTextStyles.button,
        ),
      ),
    );
  }
}
