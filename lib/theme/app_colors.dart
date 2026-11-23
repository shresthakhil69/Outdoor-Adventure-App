import 'package:flutter/material.dart';

/// Colours taken from the Figma design.
/// First block: S02 (Login) colours. Second block: S20 (Settings) colours.
class AppColors {
  // ---- Login / shared (from develop) ----
  static const background = Color(0xFFF8FAF6);
  static const surfaceMuted = Color(0xFFEDEEEB); // back button, banner card
  static const pill = Color(0xFFE7E9E5); // status pill, dividers
  static const passkeyBg = Color(0xFFF3F4F0);
  static const primary = Color(0xFF1E4D2B); // forest green buttons
  static const brandText = Color(0xFF023616);
  static const accent = Color(0xFF2C694E); // links, status dot
  static const textDark = Color(0xFF191C1A);
  static const textBody = Color(0xFF414941);
  static const textMuted = Color(0xFF717970);
  static const white = Color(0xFFFFFFFF);

  // ---- Settings screen ----
  // Backgrounds
  static const surface = Color(0xFFFFFFFF);
  static const surfaceContainer = Color(0xFFEDEEEB); // icon boxes, buttons
  static const cardTint = Color(0xFFF3F4F0);
  static const iconBgMuted = Color(0xFFE1E3DF);
  static const divider = Color(0xFFE7E9E5);

  // Text
  static const onSurface = Color(0xFF191C1A);
  static const onSurfaceVariant = Color(0xFF414941);
  static const outline = Color(0xFF717970);

  // Greens
  static const secondary = Color(0xFF2C694E);
  static const tertiaryText = Color(0xFF316E52);
  static const mint = Color(0xFFAEEECB);
  static const darkGreen = Color(0xFF023616);

  // Red / orange
  static const errorContainer = Color(0xFFFFDAD6);
  static const error = Color(0xFF93000A);
  static const rust = Color(0xFF7F2300);
  static const priority = Color(0xFFFF9472);
}