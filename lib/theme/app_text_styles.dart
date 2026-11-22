import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Text styles from the Figma design (Plus Jakarta Sans).
/// Figma line-height (px) is converted to Flutter's height multiplier.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _style({
    required double size,
    required double lineHeight,
    required FontWeight weight,
    required Color color,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static final appTitle = _style(
      size: 18, lineHeight: 22, weight: FontWeight.w600,
      color: AppColors.onSurface, letterSpacing: -0.45);

  static final pageTitle = _style(
      size: 20, lineHeight: 25, weight: FontWeight.w600,
      color: AppColors.onSurface);

  static final cardTitle = _style(
      size: 16, lineHeight: 24, weight: FontWeight.w600,
      color: AppColors.onSurface, letterSpacing: 0.15);

  static final sectionHeading = _style(
      size: 14, lineHeight: 20, weight: FontWeight.w700,
      color: AppColors.onSurface, letterSpacing: 0.7);

  static final linkTitle = _style(
      size: 14, lineHeight: 20, weight: FontWeight.w600,
      color: AppColors.onSurface, letterSpacing: 0.1);

  static final body14 = _style(
      size: 14, lineHeight: 20, weight: FontWeight.w400,
      color: AppColors.onSurfaceVariant, letterSpacing: 0.25);

  static final labelSmall = _style(
      size: 11, lineHeight: 16, weight: FontWeight.w500,
      color: AppColors.onSurfaceVariant, letterSpacing: 0.5);

  static final caption = _style(
      size: 11, lineHeight: 16, weight: FontWeight.w500,
      color: AppColors.outline, letterSpacing: 0.5);

  static final captionRegular = _style(
      size: 11, lineHeight: 16, weight: FontWeight.w400,
      color: AppColors.outline);

  static final highlight = _style(
      size: 12, lineHeight: 16, weight: FontWeight.w600,
      color: AppColors.primary, letterSpacing: 0.5);

  static final chip = _style(
      size: 11, lineHeight: 16, weight: FontWeight.w600,
      color: AppColors.onSurfaceVariant, letterSpacing: 0.5);

  static final navLabel = _style(
      size: 11, lineHeight: 16, weight: FontWeight.w500,
      color: AppColors.onSurfaceVariant, letterSpacing: -0.275);

  static final footerBold = _style(
      size: 11, lineHeight: 16, weight: FontWeight.w600,
      color: AppColors.onSurfaceVariant);

  static final footerSmall = _style(
      size: 11, lineHeight: 14, weight: FontWeight.w400,
      color: AppColors.outline);
}
