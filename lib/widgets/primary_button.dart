import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Forest-green main button (56 high, radius 16) with an optional trailing icon.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.button,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppText.style(
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppColors.white,
                  letterSpacing: 0.1,
                  lineHeightPx: 20,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, size: 14, color: AppColors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// White (or tinted) outlined-style button used for Google / Passkey options.
class SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final double gap;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.background = AppColors.white,
    this.gap = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.soft,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(width: gap),
              Text(
                label,
                style: AppText.style(
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppColors.textDark,
                  letterSpacing: 0.1,
                  lineHeightPx: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
