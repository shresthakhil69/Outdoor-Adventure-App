import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Rounded square that holds an icon (the grey boxes in the design).
class IconBox extends StatelessWidget {
  const IconBox({
    super.key,
    required this.icon,
    this.size = 36,
    this.iconSize = 18,
    this.radius = 12,
    this.background = AppColors.surfaceContainer,
    this.iconColor = AppColors.primary,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final double radius;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}
