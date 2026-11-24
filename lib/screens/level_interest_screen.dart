import 'package:flutter/material.dart';
import 'package:outdoor_adventure/models/activity.dart';
import 'package:outdoor_adventure/models/experience_level.dart';
import 'package:outdoor_adventure/theme/app_colors.dart';
import 'package:outdoor_adventure/theme/app_text_styles.dart';
import 'package:outdoor_adventure/widgets/activity_chip.dart';
import 'package:outdoor_adventure/widgets/alpine_status_bar.dart';
import 'package:outdoor_adventure/widgets/bottom_action_bar.dart';
import 'package:outdoor_adventure/widgets/brand_title.dart';
import 'package:outdoor_adventure/widgets/experience_level_card.dart';
import 'package:outdoor_adventure/widgets/profile_pill_badge.dart';
import 'package:outdoor_adventure/widgets/profile_header.dart';
import 'package:outdoor_adventure/widgets/profile_section_header.dart';
/// S04 - Level and Interests
class LevelInterestScreen extends StatefulWidget {
  const LevelInterestScreen({super.key});

  @override
  State<LevelInterestScreen> createState() => _LevelInterestScreenState();
}

class _LevelInterestScreenState extends State<LevelInterestScreen> {
  // Defaults match the Figma design.
  String _selectedLevelId = 'intermediate';
  final Set<String> _selectedActivityIds = {'trekking', 'mtb', 'camping'};

  void _toggleActivity(String id) {
    setState(() {
      if (!_selectedActivityIds.remove(id)) {
        _selectedActivityIds.add(id);
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _onComplete() {
    // Frontend only. Replace with navigation / API call later.
    _showMessage(
      'Level: $_selectedLevelId | Activities: ${_selectedActivityIds.join(', ')}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Fixed top area
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const AlpineStatusBar(
                  statusLabel: 'Alpine Grid • Active',
                  gpsLabel: 'GPS: 28.3949° N',
                ),
                ProfileHeader(
                  stepLabel: 'Step 3 of 3',
                  progressLabel: 'Profile 80%',
                  onBack: () => Navigator.maybePop(context),
                  onHelp: () => _showMessage('Help coming soon'),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandTitle(
                    eyebrow: 'Yak & Trail Nepal',
                    title: 'Your Trail Profile',
                    description:
                        'Tailor Himalayan topographic routes, AMS acclimatization paces, and trail telemetry to your experience.',
                  ),
                  const SizedBox(height: 24),

                  // Section 1: Experience level (single choice)
                  const ProfileSectionHeader(
                    title: 'Experience Level',
                    subtitle: 'Select your high-altitude comfort baseline',
                    trailing: ProfilePillBadge(label: 'Single Choice'),
                  ),
                  const SizedBox(height: 12),
                  for (final level in experienceLevels) ...[
                    ExperienceLevelCard(
                      level: level,
                      selected: _selectedLevelId == level.id,
                      onTap: () => setState(() => _selectedLevelId = level.id),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 12),

                  // Section 2: Favourite activities (multi select)
                  ProfileSectionHeader(
                    title: 'Favourite Activities',
                    subtitle: 'Tap to customize trail filters and topo overlays',
                    trailing: Text(
                      '${_selectedActivityIds.length} Selected',
                      style: AppTextStyles.badge
                          .copyWith(color: AppColors.accent),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final activity in activities)
                        ActivityChip(
                          activity: activity,
                          selected: _selectedActivityIds.contains(activity.id),
                          onTap: () => _toggleActivity(activity.id),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Docked bottom bar
          BottomActionBar(
            buttonLabel: 'Complete Profile & Enter Trails',
            helperText:
                'You can adjust altitude thresholds and activity filters anytime in Settings.',
            onPressed: _onComplete,
          ),
        ],
      ),
    );
  }
}
