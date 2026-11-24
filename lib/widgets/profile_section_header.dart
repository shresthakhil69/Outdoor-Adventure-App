import 'package:flutter/material.dart';
import 'package:outdoor_adventure/theme/app_text_styles.dart';

/// Section title + subtitle on the left, optional widget on the right.
/// Named ProfileSectionHeader so it doesn't clash with SectionHeader in section_header.dart.
class ProfileSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const ProfileSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.sectionTitle),
              Text(subtitle, style: AppTextStyles.profileCaption),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing!,
        ],
      ],
    );
  }
}