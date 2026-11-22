import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'icon_box.dart';

/// One row inside a [SettingsCard]:
/// icon box + title + optional lines of text + optional widget on the right.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor = AppColors.primary,
    this.iconBackground = AppColors.surfaceContainer,
    this.titleExtra,
    this.highlight,
    this.highlightColor = AppColors.primary,
    this.description,
    this.descriptionStyle,
    this.caption,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Color iconColor;
  final Color iconBackground;

  /// Small widget shown next to the title (badge, green dot...).
  final Widget? titleExtra;

  /// Coloured bold line under the title.
  final String? highlight;
  final Color highlightColor;

  /// Normal description line.
  final String? description;
  final TextStyle? descriptionStyle;

  /// Light grey small line at the bottom.
  final String? caption;

  /// Widget on the right side (switch, chevron, button...).
  final Widget? trailing;
  final VoidCallback? onTap;

  Widget _line(Widget child) =>
      Padding(padding: const EdgeInsets.only(top: 2), child: child);

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: IconBox(
                    icon: icon,
                    iconColor: iconColor,
                    background: iconBackground,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(title, style: AppTextStyles.cardTitle),
                          if (titleExtra != null) titleExtra!,
                        ],
                      ),
                      if (highlight != null)
                        _line(Text(
                          highlight!,
                          style: AppTextStyles.highlight
                              .copyWith(color: highlightColor),
                        )),
                      if (description != null)
                        _line(Text(
                          description!,
                          style: descriptionStyle ?? AppTextStyles.labelSmall,
                        )),
                      if (caption != null)
                        _line(Text(caption!, style: AppTextStyles.caption)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(onTap: onTap, child: content);
  }
}
