import 'package:flutter/material.dart';
import 'package:outdoor_adventure/theme/app_colors.dart';
import 'package:outdoor_adventure/theme/app_shadows.dart';
import 'package:outdoor_adventure/theme/app_text_styles.dart';

/// Docked bottom bar with the main button and a helper line.
class BottomActionBar extends StatelessWidget {
  final String buttonLabel;
  final String helperText;
  final VoidCallback? onPressed;

  const BottomActionBar({
    super.key,
    required this.buttonLabel,
    required this.helperText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xF2FFFFFF), // white, 95% opacity
        boxShadow: AppShadows.bottomBar,
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    disabledBackgroundColor: AppColors.neutralBadge,
                    elevation: 3,
                    shadowColor: const Color(0x33000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          buttonLabel,
                          style: AppTextStyles.button,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                helperText,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
