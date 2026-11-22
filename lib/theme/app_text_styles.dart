import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outdoor_adventure/theme/app_colors.dart';

/// Text styles taken from Figma (font: Plus Jakarta Sans).
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _style({
    required double size,
    required FontWeight weight,
    required double lineHeight,
    double letterSpacing = 0,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      height: lineHeight / size,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  /// "YAK & TRAIL NEPAL" (use .toUpperCase() on the text)
  static TextStyle get eyebrow => _style(
        size: 11,
        weight: FontWeight.w700,
        lineHeight: 16,
        letterSpacing: 0.55,
        color: AppColors.accent,
      );

  /// "ALPINE GRID • ACTIVE"
  static TextStyle get statusPill => _style(
        size: 11,
        weight: FontWeight.w600,
        lineHeight: 16,
        letterSpacing: 0.55,
        color: AppColors.accentText,
      );

  /// "Your Trail Profile"
  static TextStyle get pageTitle =>
      _style(size: 26, weight: FontWeight.w700, lineHeight: 34);

  /// Paragraph under the page title.
  static TextStyle get body => _style(
        size: 14,
        weight: FontWeight.w400,
        lineHeight: 20,
        letterSpacing: 0.25,
        color: AppColors.textSecondary,
      );

  /// "Experience Level", "Favourite Activities", card titles
  static TextStyle get sectionTitle => _style(
        size: 16,
        weight: FontWeight.w600,
        lineHeight: 24,
        letterSpacing: 0.15,
      );

  /// Small helper text (section subtitles, GPS text)
  static TextStyle get caption => _style(
        size: 11,
        weight: FontWeight.w500,
        lineHeight: 16,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
      );

  /// Badges and tags ("Single Choice", "Recommended", "Max 2,874m")
  static TextStyle get badge => _style(
        size: 11,
        weight: FontWeight.w600,
        lineHeight: 16,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
      );

  /// "Step 3 of 3"
  static TextStyle get stepPrimary => _style(
        size: 12,
        weight: FontWeight.w600,
        lineHeight: 16,
        letterSpacing: 0.3,
        color: AppColors.primary,
      );

  /// Activity chip text
  static TextStyle get chipLabel => _style(
        size: 14,
        weight: FontWeight.w600,
        lineHeight: 20,
        letterSpacing: 0.1,
      );

  /// Main button text
  static TextStyle get button => _style(
        size: 14,
        weight: FontWeight.w700,
        lineHeight: 20,
        letterSpacing: 0.1,
        color: AppColors.onPrimary,
      );
}
