import 'package:flutter/material.dart';

class ExperienceLevel {
  final String id;
  final String title;
  final String description;
  final String altitudeTag;
  final String note;
  final IconData icon;
  final bool recommended;

  const ExperienceLevel({
    required this.id,
    required this.title,
    required this.description,
    required this.altitudeTag,
    required this.note,
    required this.icon,
    this.recommended = false,
  });
}

/// Static data for now (frontend only). Replace with API data later.
const List<ExperienceLevel> experienceLevels = [
  ExperienceLevel(
    id: 'beginner',
    title: 'Beginner / Day Hiker',
    description:
        'Valley trails, gentle gradients (<3,000m), guided tea-house routes like Poon Hill.',
    altitudeTag: 'Max 2,874m',
    note: 'Standard Acclimatization',
    icon: Icons.directions_walk,
  ),
  ExperienceLevel(
    id: 'intermediate',
    title: 'Intermediate / Trekker',
    description:
        'High alpine passes, multi-day routes (3,000m – 5,000m), Annapurna Circuit, Langtang.',
    altitudeTag: '3,000m – 5,416m',
    note: 'Thorong La Pass ready',
    icon: Icons.hiking,
    recommended: true,
  ),
  ExperienceLevel(
    id: 'expert',
    title: 'Expert / Alpine Mountaineer',
    description:
        'Technical passes, glacier crossings (>5,000m), EBC Cho La, Mera Peak, self-supported backcountry.',
    altitudeTag: '> 5,500m & Crampons',
    note: 'Glacial Navigation',
    icon: Icons.terrain,
  ),
];
