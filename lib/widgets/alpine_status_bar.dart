import 'package:flutter/material.dart';
import 'package:outdoor_adventure/theme/app_colors.dart';
import 'package:outdoor_adventure/theme/app_shadows.dart';
import 'package:outdoor_adventure/theme/app_text_styles.dart';

/// Top row: "ALPINE GRID • ACTIVE" pill on the left, GPS reading on the right.
class AlpineStatusBar extends StatelessWidget {
  final String statusLabel;
  final String gpsLabel;

  const AlpineStatusBar({
    super.key,
    required this.statusLabel,
    required this.gpsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(999),
              boxShadow: AppShadows.small,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(statusLabel.toUpperCase(), style: AppTextStyles.statusPill),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.satellite_alt,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(gpsLabel, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
