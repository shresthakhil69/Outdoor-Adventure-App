import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// S01 - Onboarding Welcome.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _HeroSection(),
            // Commits 4-5 replace this temporary button with the white card.
            Padding(
              padding: const EdgeInsets.all(24),
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Onboarding (temporary) - go to Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Top 520px: photo + gradients + badge, logo, title, subtitle, chips.
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: 520,
      width: double.infinity,
      child: Stack(
        children: [
          const _HeroBackground(),
          Positioned(
            top: top + 16,
            left: 0,
            right: 0,
            child: const Center(child: _StatusBadge()),
          ),
          Positioned(
            top: top + 60,
            left: 0,
            right: 0,
            child: const Center(child: _LogoEmblem()),
          ),
          Positioned(
            top: top + 152,
            left: 0,
            right: 0,
            child: const _TitleBlock(),
          ),
          Positioned(
            top: top + 220,
            left: 35,
            right: 35,
            child: const _Subtitle(),
          ),
          Positioned(
            top: top + 304,
            left: 24,
            right: 24,
            child: const _ActivityChips(),
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/mountain_hero.jpg',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: const Color(0xFF2C694E)),
        ),
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
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(9999),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF1E4D2B),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'NEPAL ALPINE GRID • ACTIVE',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 16 / 11,
              letterSpacing: 0.55,
              color: const Color(0xFF023616),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoEmblem extends StatelessWidget {
  const _LogoEmblem();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 25,
              spreadRadius: -5,
              offset: Offset(0, 20)),
          BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              spreadRadius: -6,
              offset: Offset(0, 8)),
        ],
      ),
      child: const Icon(Icons.terrain, size: 48, color: Color(0xFF023616)),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'YAK & TRAIL',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 34 / 26,
            letterSpacing: -0.65,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'NEPAL BACKCOUNTRY NAVIGATION',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 16 / 12,
            letterSpacing: 1.2,
            color: const Color(0xFFB1F0CE),
          ),
        ),
      ],
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Explore the roof of the world — sacred alpine passes, '
          'glacial ridges, and untouched high Himalayan valleys.',
      textAlign: TextAlign.center,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 23 / 14,
        letterSpacing: 0.25,
        color: const Color(0xF2F3F4F0),
      ),
    );
  }
}

class _ActivityChips extends StatelessWidget {
  const _ActivityChips();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        _Chip(icon: Icons.hiking, label: 'Trek'),
        _Chip(icon: Icons.pedal_bike, label: 'MTB'),
        _Chip(icon: Icons.cabin, label: 'Camp'),
        _Chip(icon: Icons.landscape, label: 'Passes'),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(9999),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF1E4D2B)),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 16 / 11,
              letterSpacing: 0.5,
              color: const Color(0xFF023616),
            ),
          ),
        ],
      ),
    );
  }
}