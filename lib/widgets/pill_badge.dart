import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

/// Small rounded label, e.g. "3 Active", "v2.4.1 Online", "Alpine Pro Member".
class PillBadge extends StatelessWidget {
  const PillBadge({
    super.key,
    required this.text,
    required this.background,
    required this.textColor,
    this.dotColor,
    this.radius = 999,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  final String text;
  final Color background;
  final Color textColor;
  final Color? dotColor;
  final double radius;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final style = (textStyle ?? AppTextStyles.chip).copyWith(color: textColor);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          Text(text, style: style),
        ],
      ),
    );
  }
}
