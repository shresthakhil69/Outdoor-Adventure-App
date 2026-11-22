import 'package:flutter/material.dart';
import 'package:outdoor_adventure/theme/app_colors.dart';
import 'package:outdoor_adventure/theme/app_shadows.dart';
import 'package:outdoor_adventure/theme/app_text_styles.dart';

/// Back button, "Step 3 of 3 • Profile 80%" pill, and help icon.
class ProfileHeader extends StatelessWidget {
  final String stepLabel;
  final String progressLabel;
  final VoidCallback? onBack;
  final VoidCallback? onHelp;

  const ProfileHeader({
    super.key,
    required this.stepLabel,
    required this.progressLabel,
    this.onBack,
    this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Material(
            color: AppColors.surface,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBack,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.small,
                ),
                child: const Icon(Icons.arrow_back,
                    size: 20, color: AppColors.textPrimary),
              ),
            ),
          ),
          // Step pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.neutralPill,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(stepLabel, style: AppTextStyles.stepPrimary),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.textMuted,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(progressLabel, style: AppTextStyles.caption),
              ],
            ),
          ),
          // Help button
          IconButton(
            onPressed: onHelp,
            iconSize: 22,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.help_outline, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
