import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// S01 - Onboarding Welcome.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: TextButton(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          child: const Text('Onboarding (temporary) - go to Login'),
        ),
      ),
    );
  }
}