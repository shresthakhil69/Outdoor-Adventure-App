import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_toggle.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/icon_box.dart';
import '../widgets/pill_badge.dart';
import '../widgets/section_header.dart';
import '../widgets/segmented_switch.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_tile.dart';
import '../widgets/small_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _liveLocation = true;
  bool _hideGeofence = true;
  bool _telemetry = false;
  int _unitIndex = 0; // 0 = Metric, 1 = Imperial
  int _navIndex = 4; // Profile

  static const _chevron =
  Icon(Icons.chevron_right, size: 22, color: AppColors.outline);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          const _PageHeader(),
          const SizedBox(height: 20),
          const _AccountSummaryCard(),
          const SizedBox(height: 20),
          _safetySection(),
          const SizedBox(height: 20),
          _privacySection(),
          const SizedBox(height: 20),
          _preferencesSection(),
          const SizedBox(height: 20),
          const _CloudSyncCard(),
          const SizedBox(height: 28),
          const _LogoutButton(),
          const SizedBox(height: 12),
          const _Footer(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- Safety
  Widget _safetySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: Icons.wb_twilight,
          iconColor: AppColors.rust,
          title: 'Safety & Emergency Protocol',
          trailing: Text(
            'Priority 1',
            style: AppTextStyles.chip.copyWith(color: AppColors.priority),
          ),
        ),
        const SizedBox(height: 8),
        SettingsCard(
          insetDividers: true,
          children: [
            SettingsTile(
              icon: Icons.contact_emergency_outlined,
              iconColor: AppColors.error,
              iconBackground: AppColors.errorContainer,
              title: 'Emergency Contacts',
              titleExtra: const PillBadge(
                text: '3 Active',
                background: AppColors.divider,
                textColor: AppColors.onSurfaceVariant,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              ),
              description: 'Maya Sharma, HRA Responders,…',
              descriptionStyle: AppTextStyles.body14,
              caption: 'Alerted on SOS dispatch & missed check-ins',
              trailing: _chevron,
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.satellite_alt,
              iconColor: Colors.white,
              iconBackground: AppColors.primary,
              title: 'Satellite Device Pairing',
              titleExtra: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              highlight: 'Garmin inReach Mini 2 (Linked)',
              highlightColor: AppColors.secondary,
              caption: 'ANT+ & Bluetooth telemetry bridge active',
              trailing: SmallButton(label: 'Configure', onPressed: () {}),
            ),
            SettingsTile(
              icon: Icons.schedule,
              iconColor: AppColors.onSurface,
              title: 'Overdue Check-in Window',
              description: 'Default: 17:30 NPT (Teahouse Sunset Buffer)',
              caption: 'Auto-flags safety contacts after +45 min',
              trailing: SmallButton(
                label: '17:30',
                trailingIcon: Icons.edit,
                background: AppColors.cardTint,
                textColor: AppColors.primary,
                fontWeight: FontWeight.w600,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --------------------------------------------------------------- Privacy
  Widget _privacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.shield,
          title: 'Privacy & Beacon Visibility',
        ),
        const SizedBox(height: 8),
        SettingsCard(
          children: [
            SettingsTile(
              icon: Icons.my_location,
              title: 'Live Location Sharing',
              description:
              'Share live breadcrumb trail during active expeditions with expedition party & safety contacts',
              trailing: AppToggle(
                value: _liveLocation,
                onChanged: (v) => setState(() => _liveLocation = v),
              ),
              onTap: () => setState(() => _liveLocation = !_liveLocation),
            ),
            SettingsTile(
              icon: Icons.visibility_outlined,
              title: 'Profile & Trail Visibility',
              highlight: 'Public to Himalayan Community',
              caption: 'Ascents and field reviews visible to vetted mountaineers',
              trailing: const Icon(Icons.unfold_more,
                  size: 20, color: AppColors.outline),
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.grid_4x4,
              title: 'Hide Camp & Lodging Geofence',
              description:
              'Automatically conceal start/finish locations within 500m of personal lodgings & basecamps',
              trailing: AppToggle(
                value: _hideGeofence,
                onChanged: (v) => setState(() => _hideGeofence = v),
              ),
              onTap: () => setState(() => _hideGeofence = !_hideGeofence),
            ),
            SettingsTile(
              icon: Icons.analytics_outlined,
              iconColor: AppColors.onSurfaceVariant,
              title: 'Diagnostic Field Telemetry',
              description:
              'Anonymous barometric drift & battery drain sharing for Himalayan terrain algorithm updates',
              trailing: AppToggle(
                value: _telemetry,
                onChanged: (v) => setState(() => _telemetry = v),
              ),
              onTap: () => setState(() => _telemetry = !_telemetry),
            ),
          ],
        ),
      ],
    );
  }

  // ----------------------------------------------------------- Preferences
  Widget _preferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.tune,
          title: 'App & Regional Preferences',
        ),
        const SizedBox(height: 8),
        SettingsCard(
          children: [
            SettingsTile(
              icon: Icons.translate,
              title: 'Language & Dialect',
              highlight: 'English (US)',
              caption: 'अंग्रेजी / नेपाली (नेपाल) • Sherpa & Tibetan support',
              trailing: _chevron,
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.straighten,
              title: 'Units of Measurement',
              description: 'Meters, Kilometers, Celsius (°C)',
              trailing: SegmentedSwitch(
                options: const ['Metric', 'Imperial'],
                selectedIndex: _unitIndex,
                onChanged: (i) => setState(() => _unitIndex = i),
              ),
            ),
            SettingsTile(
              icon: Icons.terrain,
              title: 'Geodetic & Altitude Datum',
              highlight: 'WGS 84 / Survey of Nepal Grid',
              highlightColor: AppColors.onSurfaceVariant,
              caption: 'Calibrated for Sagarmatha / Everest survey 8848.86m',
              trailing: const Icon(Icons.tune,
                  size: 20, color: AppColors.outline),
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.download_for_offline_outlined,
              title: 'Offline Topo Map Storage',
              highlight: '2.4 GB Cached • Khumbu & Annapurna',
              highlightColor: AppColors.secondary,
              caption: 'Available without cellular or satellite uplink',
              trailing: SmallButton(label: 'Manage', onPressed: () {}),
            ),
          ],
        ),
      ],
    );
  }
}

// ===========================================================================
// Pieces that are only used on this screens
// ===========================================================================

/// Back button + "Settings" title + version pill.
class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);

    return Row(
      children: [
        Material(
          color: AppColors.surfaceContainer,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: () => Navigator.maybePop(context),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_back,
                  size: 20, color: AppColors.onSurface),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings', style: AppTextStyles.pageTitle),
              Text('Preferences & Expedition Account',
                  style: AppTextStyles.labelSmall),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const PillBadge(
          text: 'v2.4.1 Online',
          background: AppColors.mint,
          textColor: AppColors.tertiaryText,
          dotColor: AppColors.secondary,
        ),
      ],
    );
  }
}

/// Profile photo, name, badges and "Manage Account" link.
class _AccountSummaryCard extends StatelessWidget {
  const _AccountSummaryCard();

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      insetDividers: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/pemba_dorje.jpg',
                          fit: BoxFit.cover,
                          // Shown until you add the real photo
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.divider,
                            child: const Icon(Icons.person,
                                size: 28, color: AppColors.outline),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text('Pemba Dorje',
                              style: AppTextStyles.cardTitle),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified,
                            size: 16, color: AppColors.primary),
                      ],
                    ),
                    Text('@pemba_dorje • Solukhumbu, Nepal',
                        style: AppTextStyles.labelSmall),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        PillBadge(
                          text: 'Alpine Pro Member',
                          background: AppColors.mint,
                          textColor: AppColors.tertiaryText,
                          radius: 6,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          textStyle: AppTextStyles.chip.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.25,
                          ),
                        ),
                        Text('Himalayan Certified',
                            style: AppTextStyles.captionRegular),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                const IconBox(
                  icon: Icons.manage_accounts_outlined,
                  size: 32,
                  iconSize: 16,
                  radius: 8,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Manage Account & Credentials',
                          style: AppTextStyles.linkTitle),
                      Text('Password, multi-factor & rescue ID',
                          style: AppTextStyles.labelSmall),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    size: 22, color: AppColors.outline),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Grey card at the bottom: "Cloud Sync & Tile Cache".
class _CloudSyncCard extends StatelessWidget {
  const _CloudSyncCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardTint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const IconBox(
            icon: Icons.cloud_sync_outlined,
            background: AppColors.iconBgMuted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cloud Sync & Tile Cache', style: AppTextStyles.cardTitle),
                Text('Last synced 09:42 NPT • 3 trails queued',
                    style: AppTextStyles.labelSmall),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SmallButton(
            label: 'Clear\nTiles',
            background: Colors.white,
            textColor: AppColors.primary,
            fontWeight: FontWeight.w600,
            radius: 999,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);

    return SizedBox(
      height: 52,
      child: Material(
        color: AppColors.errorContainer,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, size: 18, color: AppColors.error),
              const SizedBox(width: 8),
              Text(
                'Log Out of Yak & Trail',
                style: AppTextStyles.linkTitle.copyWith(color: AppColors.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.health_and_safety_outlined,
                  size: 13, color: AppColors.rust),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Himalayan Rescue Association Official Partner',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.footerBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Yak & Trail v2.4.1 (Build 8848) • High-Altitude Expedition Engine. '
                'Crafted with care in Kathmandu & Namche Bazaar, Nepal',
            textAlign: TextAlign.center,
            style: AppTextStyles.footerSmall,
          ),
        ],
      ),
    );
  }
}
