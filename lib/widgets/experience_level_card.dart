import 'package:flutter/material.dart';
import 'package:outdoor_adventure/models/experience_level.dart';
import 'package:outdoor_adventure/theme/app_colors.dart';
import 'package:outdoor_adventure/theme/app_shadows.dart';
import 'package:outdoor_adventure/theme/app_text_styles.dart';
import 'package:outdoor_adventure/widgets/pill_badge.dart';

/// One radio-style card in the "Experience Level" section.
class ExperienceLevelCard extends StatelessWidget {
  final ExperienceLevel level;
  final bool selected;
  final VoidCallback onTap;

  const ExperienceLevelCard({
    super.key,
    required this.level,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      inMutuallyExclusiveGroup: true,
      selected: selected,
      label: level.title,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected ? AppShadows.medium : AppShadows.small,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _IconBox(icon: level.icon, selected: selected),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: _Details(level: level, selected: selected),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: _RadioIndicator(selected: selected),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final bool selected;

  const _IconBox({required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.neutralPill,
        borderRadius: BorderRadius.circular(12),
        boxShadow: selected ? AppShadows.small : null,
      ),
      child: Icon(
        icon,
        size: 24,
        color: selected ? AppColors.onPrimary : AppColors.textSecondary,
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final ExperienceLevel level;
  final bool selected;

  const _Details({required this.level, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(level.title, style: AppTextStyles.sectionTitle),
            if (level.recommended)
              const PillBadge(
                label: 'Recommended',
                backgroundColor: AppColors.mint,
                textColor: AppColors.accentText,
                weight: FontWeight.w700,
              ),
          ],
        ),
        const SizedBox(height: 2),
        Text(level.description, style: AppTextStyles.body),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: selected ? AppColors.mint : AppColors.neutralTag,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  level.altitudeTag,
                  style: AppTextStyles.badge.copyWith(
                    color:
                        selected ? AppColors.accentText : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
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
            Expanded(child: Text(level.note, style: AppTextStyles.caption)),
          ],
        ),
      ],
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  final bool selected;

  const _RadioIndicator({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.neutralBadge,
        shape: BoxShape.circle,
        boxShadow: selected ? AppShadows.small : null,
      ),
      child: Center(
        child: selected
            ? const Icon(Icons.check, size: 14, color: AppColors.onPrimary)
            : Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
              ),
      ),
    );
  }
}
