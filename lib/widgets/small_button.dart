import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Small button used on the right side of tiles (Configure, Manage, 17:30...).
class SmallButton extends StatelessWidget {
  const SmallButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.background = AppColors.surfaceContainer,
    this.textColor = AppColors.onSurface,
    this.fontWeight = FontWeight.w500,
    this.radius = 8,
    this.trailingIcon,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  final String label;
  final VoidCallback onPressed;
  final Color background;
  final Color textColor;
  final FontWeight fontWeight;
  final double radius;
  final IconData? trailingIcon;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);

    return Material(
      color: background,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.labelSmall
                    .copyWith(color: textColor, fontWeight: fontWeight),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 4),
                Icon(trailingIcon, size: 12, color: textColor),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
