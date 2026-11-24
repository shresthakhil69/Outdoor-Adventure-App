import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/pill_badge.dart';

/// Expedition Home & Saved Trails Dashboard.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class SavedTrail {
  final String title;
  final String location;
  final String distance;
  final String elevation;
  final String cacheSize;
  final bool isOffline;
  final String status;

  const SavedTrail({
    required this.title,
    required this.location,
    required this.distance,
    required this.elevation,
    required this.cacheSize,
    required this.isOffline,
    required this.status,
  });
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0; // Home

  // Saved trails data stored in state / persistent memory
  final List<SavedTrail> _savedTrails = const [
    SavedTrail(
      title: 'Annapurna Circuit & Thorong La Pass',
      location: 'Mustang & Manang, Nepal',
      distance: '160 km',
      elevation: '5,416m',
      cacheSize: '1.2 GB',
      isOffline: true,
      status: 'Ready Offline',
    ),
    SavedTrail(
      title: 'Everest Base Camp & Kala Patthar',
      location: 'Khumbu Region, Nepal',
      distance: '130 km',
      elevation: '5,545m',
      cacheSize: '950 MB',
      isOffline: true,
      status: 'Ready Offline',
    ),
    SavedTrail(
      title: 'Langtang Valley & Kyanjin Ri',
      location: 'Rasuwa, Nepal',
      distance: '77 km',
      elevation: '4,773m',
      cacheSize: '420 MB',
      isOffline: true,
      status: 'Ready Offline',
    ),
  ];

  void _onNavTap(int index) {
    if (index == 4) {
      // Profile / Settings tab
      Navigator.pushNamed(context, '/settings');
    } else {
      setState(() => _navIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _buildWelcomeHeader(),
          const SizedBox(height: 20),
          _buildSavedTrailsHeader(),
          const SizedBox(height: 12),
          for (final trail in _savedTrails) ...[
            _buildTrailCard(trail),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x201E4D2B),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Namaste, Pemba! 🙏',
                style: AppTextStyles.pageTitle.copyWith(color: Colors.white),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/settings'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.settings, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'High-Altitude Expedition Engine Active • All saved trails synced.',
            style: AppTextStyles.labelSmall
                .copyWith(color: Colors.white.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedTrailsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.bookmark_outlined,
                size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Saved Trails', style: AppTextStyles.pageTitle),
          ],
        ),
        PillBadge(
          text: '${_savedTrails.length} Saved',
          background: AppColors.surfaceContainer,
          textColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildTrailCard(SavedTrail trail) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A191C1A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    trail.title,
                    style: AppTextStyles.cardTitle,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.download_done,
                          size: 12, color: AppColors.tertiaryText),
                      const SizedBox(width: 4),
                      Text(
                        trail.status,
                        style: AppTextStyles.chip.copyWith(
                          fontSize: 10,
                          color: AppColors.tertiaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              trail.location,
              style: AppTextStyles.labelSmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTrailMetric(Icons.straighten, trail.distance),
                const SizedBox(width: 16),
                _buildTrailMetric(Icons.terrain, 'Max ${trail.elevation}'),
                const SizedBox(width: 16),
                _buildTrailMetric(Icons.sd_storage, trail.cacheSize),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailMetric(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
