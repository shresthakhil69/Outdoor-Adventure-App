import 'package:flutter/material.dart';

/// Every color from the Figma design (S04 - Level and Interests).
class AppColors {
  AppColors._();

  static const Color background = Color(0xFFF8FAF6);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color primary = Color(0xFF1E4D2B); // dark green: buttons, selected
  static const Color accent = Color(0xFF2C694E); // eyebrow text, dots
  static const Color accentText = Color(0xFF316E52); // text on mint
  static const Color mint = Color(0xFFAEEECB); // badges, selected tags

  static const Color textPrimary = Color(0xFF191C1A);
  static const Color textSecondary = Color(0xFF414941);
  static const Color textMuted = Color(0xFF717970);

  static const Color neutralPill = Color(0xFFE7E9E5); // step pill, icon boxes
  static const Color neutralBadge = Color(0xFFE1E3DF); // "Single Choice", radio
  static const Color neutralTag = Color(0xFFEDEEEB); // small stat tags

  static const Color onPrimary = Color(0xFFFFFFFF);
}
