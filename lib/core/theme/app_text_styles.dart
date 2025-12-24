import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Helper method to get responsive font size (85% to 115% based on screen size)
  static double _getResponsiveFontSize(BuildContext? context, double baseSize) {
    if (context == null) return baseSize;
    try {
      final mediaQuery = MediaQuery.of(context);
      final textScaleFactor = mediaQuery.textScaleFactor.clamp(0.85, 1.15);
      return baseSize * textScaleFactor;
    } catch (e) {
      return baseSize;
    }
  }

  // Display - Large titles
  static TextStyle get display => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // Title - Section headers
  static TextStyle get title => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Heading - Subsection headers
  static TextStyle get heading => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body - Regular text
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Caption - Small descriptive text
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  // Button - Call to action text
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );

  // Responsive versions (use these when you have BuildContext)
  static TextStyle displayResponsive(BuildContext context) => display.copyWith(
    fontSize: _getResponsiveFontSize(context, 32),
  );

  static TextStyle titleResponsive(BuildContext context) => title.copyWith(
    fontSize: _getResponsiveFontSize(context, 24),
  );

  static TextStyle headingResponsive(BuildContext context) => heading.copyWith(
    fontSize: _getResponsiveFontSize(context, 18),
  );

  static TextStyle bodyResponsive(BuildContext context) => body.copyWith(
    fontSize: _getResponsiveFontSize(context, 16),
  );

  static TextStyle captionResponsive(BuildContext context) => caption.copyWith(
    fontSize: _getResponsiveFontSize(context, 14),
  );

  static TextStyle buttonResponsive(BuildContext context) => button.copyWith(
    fontSize: _getResponsiveFontSize(context, 16),
  );
}
