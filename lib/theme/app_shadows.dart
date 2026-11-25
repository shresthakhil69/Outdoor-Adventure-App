import 'package:flutter/material.dart';

/// Shadows for the Level and Interests screen (Biraj).
/// Named ProfileShadows so it doesn't clash with AppShadows in app_theme.dart.
class ProfileShadows {
  ProfileShadows._();

  /// Resting cards, chips and buttons.
  static const List<BoxShadow> small = [
    BoxShadow(color: Color(0x0D000000), offset: Offset(0, 1), blurRadius: 2),
  ];

  /// Selected card / primary button.
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
  ];

  /// Docked bottom bar (shadow points upwards).
  static const List<BoxShadow> bottomBar = [
    BoxShadow(color: Color(0x14000000), offset: Offset(0, -4), blurRadius: 16),
  ];
}