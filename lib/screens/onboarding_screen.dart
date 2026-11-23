import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// S01 - Onboarding Welcome.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const _HeroBackground(),
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Onboarding (temporary) - go to Login'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _HeroBackground extends StatelessWidget {
  const _HeroBackground();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Photo. If the file is missing, a green colour shows instead.
          Image.asset(
            'assets/images/mountain_hero.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF2C694E)),
          ),
          // Gradient 1: dark green at the top, fading into the page colour.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xB3023616), Color(0x40023616), AppColors.background],
                stops: [0, 0.5, 1],
              ),
            ),
          ),
          // Gradient 2: soft light fade at the bottom, slight shade at the top.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.background, Color(0x00F8FAF6), Color(0x4D000000)],
                stops: [0, 0.5, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}