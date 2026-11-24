import 'package:flutter/material.dart';
import 'package:outdoor_adventure/theme/app_colors.dart';
import 'package:outdoor_adventure/theme/app_shadows.dart';
import 'package:outdoor_adventure/theme/app_text_styles.dart';

/// Logo square + "YAK & TRAIL NEPAL" + "Your Trail Profile" + description.
class BrandTitle extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String description;

  const BrandTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: ProfileShadows.small,
              ),
              child: const Icon(Icons.landscape,
                  size: 22, color: AppColors.onPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eyebrow.toUpperCase(), style: AppTextStyles.eyebrow),
                  const SizedBox(height: 2),
                  Text(title, style: AppTextStyles.profileTitle),                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(description, style: AppTextStyles.body),
      ],
    );
  }
}
