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
  String _selectedLanguage = 'English (US)';
  String _visibilityState = 'Public to Himalayan Community';
  String _selectedDatum = 'WGS 84 / Survey of Nepal Grid';
  String _checkInTime = '17:30';
  bool _tilesCleared = false;

  static const _chevron =
      Icon(Icons.chevron_right, size: 22, color: AppColors.outline);

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
          _AccountSummaryCard(
            onManageAccount: () => _showManageAccountDialog(context),
          ),
          const SizedBox(height: 20),
          _safetySection(),
          const SizedBox(height: 20),
          _privacySection(),
          const SizedBox(height: 20),
          _preferencesSection(),
          const SizedBox(height: 20),
          _CloudSyncCard(
            tilesCleared: _tilesCleared,
            onClearTiles: () {
              setState(() => _tilesCleared = true);
              _showSnackBar('Offline topo tile cache cleared (2.4 GB freed)');
            },
          ),
          const SizedBox(height: 28),
          _LogoutButton(
            onLogout: () => _showLogoutDialog(context),
          ),
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
              onTap: () => _showEmergencyContactsSheet(context),
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
              trailing: SmallButton(
                label: 'Configure',
                onPressed: () => _showSatelliteDialog(context),
              ),
            ),
            SettingsTile(
              icon: Icons.schedule,
              iconColor: AppColors.onSurface,
              title: 'Overdue Check-in Window',
              description: 'Default: $_checkInTime NPT (Teahouse Sunset Buffer)',
              caption: 'Auto-flags safety contacts after +45 min',
              trailing: SmallButton(
                label: _checkInTime,
                trailingIcon: Icons.edit,
                background: AppColors.cardTint,
                textColor: AppColors.primary,
                fontWeight: FontWeight.w600,
                onPressed: () => _pickCheckInTime(context),
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
                onChanged: (v) {
                  setState(() => _liveLocation = v);
                  _showSnackBar(v
                      ? 'Live location sharing enabled'
                      : 'Live location sharing paused');
                },
              ),
              onTap: () {
                setState(() => _liveLocation = !_liveLocation);
                _showSnackBar(_liveLocation
                    ? 'Live location sharing enabled'
                    : 'Live location sharing paused');
              },
            ),
            SettingsTile(
              icon: Icons.visibility_outlined,
              title: 'Profile & Trail Visibility',
              highlight: _visibilityState,
              caption:
                  'Ascents and field reviews visible to vetted mountaineers',
              trailing: const Icon(Icons.unfold_more,
                  size: 20, color: AppColors.outline),
              onTap: () => _showVisibilitySheet(context),
            ),
            SettingsTile(
              icon: Icons.grid_4x4,
              title: 'Hide Camp & Lodging Geofence',
              description:
                  'Automatically conceal start/finish locations within 500m of personal lodgings & basecamps',
              trailing: AppToggle(
                value: _hideGeofence,
                onChanged: (v) {
                  setState(() => _hideGeofence = v);
                  _showSnackBar(v
                      ? 'Lodging geofence enabled (500m buffer)'
                      : 'Lodging geofence disabled');
                },
              ),
              onTap: () {
                setState(() => _hideGeofence = !_hideGeofence);
                _showSnackBar(_hideGeofence
                    ? 'Lodging geofence enabled (500m buffer)'
                    : 'Lodging geofence disabled');
              },
            ),
            SettingsTile(
              icon: Icons.analytics_outlined,
              iconColor: AppColors.onSurfaceVariant,
              title: 'Diagnostic Field Telemetry',
              description:
                  'Anonymous barometric drift & battery drain sharing for Himalayan terrain algorithm updates',
              trailing: AppToggle(
                value: _telemetry,
                onChanged: (v) {
                  setState(() => _telemetry = v);
                  _showSnackBar(v
                      ? 'Field telemetry enabled'
                      : 'Field telemetry disabled');
                },
              ),
              onTap: () {
                setState(() => _telemetry = !_telemetry);
                _showSnackBar(_telemetry
                    ? 'Field telemetry enabled'
                    : 'Field telemetry disabled');
              },
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
              highlight: _selectedLanguage,
              caption: 'अंग्रेजी / नेपाली (नेपाल) • Sherpa & Tibetan support',
              trailing: _chevron,
              onTap: () => _showLanguageSheet(context),
            ),
            SettingsTile(
              icon: Icons.straighten,
              title: 'Units of Measurement',
              description: _unitIndex == 0
                  ? 'Meters, Kilometers, Celsius (°C)'
                  : 'Feet, Miles, Fahrenheit (°F)',
              trailing: SegmentedSwitch(
                options: const ['Metric', 'Imperial'],
                selectedIndex: _unitIndex,
                onChanged: (i) {
                  setState(() => _unitIndex = i);
                  _showSnackBar(
                      'Units changed to ${i == 0 ? "Metric" : "Imperial"}');
                },
              ),
            ),
            SettingsTile(
              icon: Icons.terrain,
              title: 'Geodetic & Altitude Datum',
              highlight: _selectedDatum,
              highlightColor: AppColors.onSurfaceVariant,
              caption: 'Calibrated for Sagarmatha / Everest survey 8848.86m',
              trailing: const Icon(Icons.tune,
                  size: 20, color: AppColors.outline),
              onTap: () => _showDatumSheet(context),
            ),
            SettingsTile(
              icon: Icons.download_for_offline_outlined,
              title: 'Offline Topo Map Storage',
              highlight: _tilesCleared
                  ? 'Cache Empty • 0.0 GB Cached'
                  : '2.4 GB Cached • Khumbu & Annapurna',
              highlightColor: AppColors.secondary,
              caption: 'Available without cellular or satellite uplink',
              trailing: SmallButton(
                label: 'Manage',
                onPressed: () => _showOfflineStorageDialog(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ----------------------------------------------------------- Dialogs & Sheets
  void _showEmergencyContactsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Emergency Contacts', style: AppTextStyles.pageTitle),
            const SizedBox(height: 4),
            Text('Notified instantly during SOS dispatches & overdue alerts.',
                style: AppTextStyles.labelSmall),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(child: Text('MS')),
              title: const Text('Maya Sharma'),
              subtitle: const Text('+977 980-1234567 • Primary Contact'),
              trailing: const Icon(Icons.check_circle, color: AppColors.primary),
            ),
            ListTile(
              leading: const CircleAvatar(child: Text('HR')),
              title: const Text('HRA Responders (Feriche & Pheriche)'),
              subtitle: const Text('VHF Ch 14 / Satellite Rescue Team'),
              trailing: const Icon(Icons.check_circle, color: AppColors.primary),
            ),
            ListTile(
              leading: const CircleAvatar(child: Text('NB')),
              title: const Text('Namche Basecamp Dispatch'),
              subtitle: const Text('+977 38-540102'),
              trailing: const Icon(Icons.check_circle, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  _showSnackBar('Add Contact feature opened');
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Emergency Contact'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSatelliteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.satellite_alt, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Satellite Telemetry'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connected Device: Garmin inReach Mini 2',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Protocol: ANT+ & Bluetooth Low Energy\n'
                '• Signal Strength: Strong (5/5 Satellite Locks)\n'
                '• Battery Level: 84%\n'
                '• SOS Relay: Active via Iridium Network'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackBar('Re-synchronizing satellite bridge...');
            },
            child: const Text('Sync Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCheckInTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 17, minute: 30),
    );
    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() => _checkInTime = formatted);
      _showSnackBar('Check-in deadline set to $formatted NPT');
    }
  }

  void _showVisibilitySheet(BuildContext context) {
    final options = [
      'Public to Himalayan Community',
      'Expedition Party & Guides Only',
      'Private (Only Me)',
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text('Profile & Trail Visibility',
                style: AppTextStyles.pageTitle),
          ),
          for (final opt in options)
            RadioListTile<String>(
              value: opt,
              groupValue: _visibilityState,
              title: Text(opt),
              activeColor: AppColors.primary,
              onChanged: (val) {
                if (val != null) {
                  setState(() => _visibilityState = val);
                  Navigator.pop(ctx);
                  _showSnackBar('Visibility updated: $val');
                }
              },
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final languages = [
      'English (US)',
      'Nepali (नेपाल)',
      'Sherpa (Sharwa)',
      'Tibetan (Bod Skad)',
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text('Select Language & Dialect',
                style: AppTextStyles.pageTitle),
          ),
          for (final lang in languages)
            RadioListTile<String>(
              value: lang,
              groupValue: _selectedLanguage,
              title: Text(lang),
              activeColor: AppColors.primary,
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedLanguage = val);
                  Navigator.pop(ctx);
                  _showSnackBar('Language set to $val');
                }
              },
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showDatumSheet(BuildContext context) {
    final datums = [
      'WGS 84 / Survey of Nepal Grid',
      'NAD83 / Everest 1830 Datum',
      'UTM Zone 45N (Himalayas)',
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text('Geodetic & Altitude Datum',
                style: AppTextStyles.pageTitle),
          ),
          for (final datum in datums)
            RadioListTile<String>(
              value: datum,
              groupValue: _selectedDatum,
              title: Text(datum),
              activeColor: AppColors.primary,
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedDatum = val);
                  Navigator.pop(ctx);
                  _showSnackBar('Datum updated: $val');
                }
              },
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showOfflineStorageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Offline Topo Map Storage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_tilesCleared
                ? 'Current Cache: 0.0 GB'
                : 'Current Cache: 2.4 GB'),
            const SizedBox(height: 8),
            const Text('• Khumbu Valley High-Res: 1.8 GB\n'
                '• Annapurna Circuit Topo: 600 MB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              setState(() => _tilesCleared = true);
              Navigator.pop(ctx);
              _showSnackBar('Map cache cleared');
            },
            child: const Text('Clear Storage',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showManageAccountDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expedition Account', style: AppTextStyles.pageTitle),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Pemba Dorje'),
              subtitle: Text('@pemba_dorje'),
            ),
            const ListTile(
              leading: Icon(Icons.badge_outlined),
              title: Text('Himalayan Rescue ID'),
              subtitle: Text('HRA-NEP-8848-2024'),
            ),
            const ListTile(
              leading: Icon(Icons.security),
              title: Text('Two-Factor Authentication'),
              subtitle: Text('Active (SMS & Authenticator)'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of Yak & Trail?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Pieces that are only used on this screen
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
  const _AccountSummaryCard({required this.onManageAccount});

  final VoidCallback onManageAccount;

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
                          errorBuilder: (context, error, stackTrace) => Container(
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
          onTap: onManageAccount,
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
  const _CloudSyncCard({
    required this.tilesCleared,
    required this.onClearTiles,
  });

  final bool tilesCleared;
  final VoidCallback onClearTiles;

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
                Text(
                    tilesCleared
                        ? 'Cache cleared • 0.0 GB queued'
                        : 'Last synced 09:42 NPT • 3 trails queued',
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
            onPressed: onClearTiles,
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onLogout});

  final VoidCallback onLogout;

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
          onTap: onLogout,
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
