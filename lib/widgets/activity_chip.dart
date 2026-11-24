import 'package:flutter/material.dart';
import 'package:outdoor_adventure/models/activity.dart';
import 'package:outdoor_adventure/theme/app_colors.dart';
import 'package:outdoor_adventure/theme/app_shadows.dart';
import 'package:outdoor_adventure/theme/app_text_styles.dart';

/// Multi-select chip in the "Favourite Activities" section.
class ActivityChip extends StatelessWidget {
  final Activity activity;
  final bool selected;
  final VoidCallback onTap;

  const ActivityChip({
    super.key,
    required this.activity,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: activity.label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: const BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: ProfileShadows.small,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    activity.icon,
                    size: 18,
                    color: selected
                        ? AppColors.onPrimary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      activity.label,
                      style: AppTextStyles.chipLabel.copyWith(
                        color: selected
                            ? AppColors.onPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(width: 10),
                    const Icon(Icons.check,
                        size: 16, color: AppColors.onPrimary),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
