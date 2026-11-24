import 'package:flutter/material.dart';
import 'package:outdoor_adventure/theme/app_colors.dart';
import 'package:outdoor_adventure/theme/app_text_styles.dart';

/// Small rounded label: "Single Choice", "Recommended".
/// Named ProfilePillBadge so it doesn't clash with PillBadge in pill_badge.dart.
class ProfilePillBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight? weight;

  const ProfilePillBadge({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.neutralBadge,
    this.textColor = AppColors.textSecondary,
    this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.badge.copyWith(color: textColor, fontWeight: weight),
      ),
    );
  }
}