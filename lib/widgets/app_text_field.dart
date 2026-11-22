import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Labelled input: 12px label, 56 high white field, radius 16, icon on the left.
class AppTextField extends StatelessWidget {
  final String label;
  final Widget? labelTrailing; // for the "Forgot password?" link
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? hint;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.prefixIcon,
    this.labelTrailing,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.validator,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppText.style(
      size: 12,
      weight: FontWeight.w600,
      color: AppColors.textBody,
      letterSpacing: 0.5,
      lineHeightPx: 16,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: labelStyle),
              if (labelTrailing != null) labelTrailing!,
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.soft,
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            style: AppText.style(
              size: 16,
              weight: FontWeight.w400,
              color: AppColors.textDark,
              letterSpacing: 0.5,
              lineHeightPx: 20,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppText.style(
                size: 16,
                weight: FontWeight.w400,
                color: AppColors.textMuted,
                letterSpacing: 0.5,
              ),
              filled: true,
              fillColor: AppColors.white,
              prefixIcon: Icon(prefixIcon, size: 20, color: AppColors.textBody),
              prefixIconConstraints: const BoxConstraints(minWidth: 48),
              suffixIcon: suffix,
              contentPadding: const EdgeInsets.symmetric(vertical: 17.5, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
