import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/app_bottom_nav.dart';
import '../widgets/app_top_bar.dart';

/// Home-only tokens from the S05 spec (private, so they don't clash with
/// the shared AppColors in ../theme/app_colors.dart).
class _HomeColors {
  static const bg = Color(0xFFF8FAF6);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceLow = Color(0xFFF3F4F0);
  static const chip = Color(0xFFE7E9E5);
  static const divider = Color(0xFFC1C9BE);
  static const text = Color(0xFF191C1A);
  static const textSoft = Color(0xFF414941);
  static const hint = Color(0xFF717970);
  static const primary = Color(0xFF1E4D2B);
  static const accent = Color(0xFF2C694E);
  static const mint = Color(0xFFAEEECB);
  static const mintText = Color(0xFF316E52);
  static const danger = Color(0xFF7F2300);
  static const dangerBg = Color(0xFFFFF5F2);
  static const dangerText = Color(0xFF591600);
  static const star = Color(0xFFF59E0B);
}

TextStyle _t(double size, FontWeight w,
    {Color color = _HomeColors.text, double? height, double? spacing}) =>
    GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: w,
      color: color,
      height: height != null ? height / size : null,
      letterSpacing: spacing,
    );

const _cardShadow = [
  BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _filter = 0;
  int _navIndex = 0; // Home

  static const _filters = [
    (Icons.hiking, 'All Trails'),
    (Icons.landscape, 'Trekking (3,000m+)'),
    (Icons.pedal_bike, 'MTB Loops'),
    (Icons.temple_buddhist, 'Pilgrimage'),
    (Icons.local_cafe, 'Teahouse Routes'),
  ];

  static const _trails = [
    _Trail('Poon Hill Sunrise Trek', 'Ghorepani • Rhododendron Woods',
        'Moderate', '4.9', '1.2k', '11.8 km', '+1,120m', '4h 30m',
        'assets/images/poon_hill.jpg'),
    _Trail('Phewa Lake Ridge Circuit', 'Pokhara Rim • Singletrack MTB',
        'Intermediate', '4.8', '860', '24.5 km', '+640m', '2h 15m',
        'assets/images/phewa_ridge.jpg'),
    _Trail('Sarangkot Viewpoint Trail', 'Old Village Stairway • Valley Panoramas',
        'Easy', '4.7', '2.1k', '5.2 km', '+520m', '1h 45m',
        'assets/images/sarangkot.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _HomeColors.bg,
      appBar: const AppTopBar(),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (i) {
          // TODO: navigate to the other tabs the same way SettingsScreen does
          setState(() => _navIndex = i);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _GreetingHeader(),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _SearchBar(),
            ),
            const SizedBox(height: 12),
            _buildFilters(),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _AdvisoryBanner(
                title: 'Weather Advisory',
                updated: 'Updated 15m ago',
                message:
                'Thorong La Pass (5,416m) — Heavy snowfall warning above 4,800m. Technical crampons required.',
                linkText: 'View Mountain Safety Protocol',
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _SectionHeader(
                title: 'Nearby Trails',
                caption: 'Within 35 km',
                action: 'See all (24)',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 318,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                itemCount: _trails.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) => _TrailCard(trail: _trails[i]),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _SectionHeader(
                title: 'Featured Expeditions',
                caption: 'Himalayan Classics',
                action: 'Explore Regions',
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _ExpeditionCard(
                    image: 'assets/images/annapurna.jpg',
                    badge: 'Sherpa Guided Route',
                    badgeIcon: Icons.verified_outlined,
                    badgeFilled: true,
                    secondBadge: 'TIMS Required',
                    title: 'Annapurna Circuit: High Alpine Crossing',
                    subtitle: 'Manang & Mustang Districts • Western Nepal',
                    tags: const [
                      'Multi-Day Trek',
                      'Thorong La Pass (5,416m)',
                      'Teahouse Route'
                    ],
                    distance: '160 km',
                    duration: '12–14 Days',
                    extraIcon: Icons.cloud_done_outlined,
                    extra: '100% Offline Topo',
                    extraColor: _HomeColors.primary,
                    onLoad: () {},
                    onBookmark: () {},
                  ),
                  const SizedBox(height: 16),
                  _ExpeditionCard(
                    image: 'assets/images/langtang.jpg',
                    badge: 'Flora Sanctuary',
                    badgeIcon: Icons.eco_outlined,
                    badgeFilled: false,
                    secondBadge: 'Permit Available On-Trail',
                    title: 'Langtang Valley & Kyanjin Gompa',
                    subtitle: 'Rasuwa District • Tamang Heritage Trail',
                    tags: const [
                      'Glacial Valley',
                      '3,870m Peak',
                      'Tamang Culture'
                    ],
                    distance: '68 km',
                    duration: '6–7 Days',
                    extraIcon: Icons.health_and_safety_outlined,
                    extra: 'Low AMS Risk',
                    extraColor: _HomeColors.accent,
                    onLoad: () {},
                    onBookmark: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final selected = i == _filter;
          final f = _filters[i];
          return GestureDetector(
            onTap: () => setState(() => _filter = i),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: selected ? _HomeColors.primary : _HomeColors.surface,
                borderRadius: BorderRadius.circular(999),
                boxShadow: selected ? _cardShadow : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(f.$1,
                      size: 16,
                      color: selected ? Colors.white : _HomeColors.accent),
                  const SizedBox(width: 6),
                  Text(
                    f.$2,
                    style: _t(12, FontWeight.w600,
                        color: selected ? Colors.white : _HomeColors.text,
                        spacing: 0.5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Greeting + SOS
// ---------------------------------------------------------------------------

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text('Namaste, Tenzing',
                        overflow: TextOverflow.ellipsis,
                        style: _t(20, FontWeight.w600,
                            height: 28, spacing: -0.5)),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.landscape,
                      size: 18, color: _HomeColors.accent),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _HomeColors.chip,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.my_location,
                        size: 13, color: _HomeColors.accent),
                    const SizedBox(width: 6),
                    Text('Pokhara (822m) • Clear 18°C',
                        style: _t(11, FontWeight.w500,
                            color: _HomeColors.textSoft, spacing: 0.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _HomeColors.surfaceLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.cloud_done_outlined,
                  size: 22, color: _HomeColors.accent),
            ),
            const SizedBox(width: 8),
            Material(
              color: _HomeColors.danger,
              borderRadius: BorderRadius.circular(12),
              elevation: 0.5,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // TODO: trigger SOS flow
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        const Icon(Icons.sos, size: 20, color: Colors.white),
                        const SizedBox(width: 6),
                        Text('SOS',
                            style: _t(12, FontWeight.w700,
                                color: Colors.white, spacing: 0.6)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Search
// ---------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.only(left: 16, right: 6),
      decoration: BoxDecoration(
        color: _HomeColors.surface,
        borderRadius: BorderRadius.circular(999),
        boxShadow: _cardShadow,
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 22, color: _HomeColors.hint),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: _t(14, FontWeight.w400, spacing: 0.25),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Search trails, peaks, teahouses...',
                hintStyle: _t(14, FontWeight.w400,
                    color: _HomeColors.hint, spacing: 0.25),
              ),
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: _HomeColors.surfaceLow,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune, size: 20, color: _HomeColors.textSoft),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Advisory banner
// ---------------------------------------------------------------------------

class _AdvisoryBanner extends StatelessWidget {
  final String title, updated, message, linkText;
  const _AdvisoryBanner({
    required this.title,
    required this.updated,
    required this.message,
    required this.linkText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _HomeColors.dangerBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: _HomeColors.danger,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.warning_amber_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(title.toUpperCase(),
                          style: _t(12, FontWeight.w700,
                              color: _HomeColors.danger, spacing: 0.3)),
                    ),
                    Text(updated,
                        style: _t(11, FontWeight.w500,
                            color: const Color(0xFF842500), spacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(message,
                    style: _t(14, FontWeight.w600,
                        color: _HomeColors.dangerText,
                        height: 19,
                        spacing: 0.25)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    // TODO: open safety protocol
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(linkText,
                          style: _t(12, FontWeight.w700,
                              color: _HomeColors.dangerText, spacing: 0.5)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward,
                          size: 13, color: _HomeColors.dangerText),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title, caption, action;
  const _SectionHeader(
      {required this.title, required this.caption, required this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 3,
          child: Text(title,
              style: _t(18, FontWeight.w700, height: 24, spacing: 0.15)),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 2,
          child: Text(caption,
              style: _t(12, FontWeight.w500,
                  color: _HomeColors.textSoft, spacing: 0.5)),
        ),
        const Spacer(),
        Text(action,
            textAlign: TextAlign.right,
            style: _t(12, FontWeight.w600,
                color: _HomeColors.accent, spacing: 0.5)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Nearby trail card
// ---------------------------------------------------------------------------

class _Trail {
  final String title, subtitle, level, rating, reviews;
  final String distance, elevation, duration, image;
  const _Trail(this.title, this.subtitle, this.level, this.rating,
      this.reviews, this.distance, this.elevation, this.duration, this.image);
}

class _TrailCard extends StatelessWidget {
  final _Trail trail;
  const _TrailCard({required this.trail});

  Color get _levelColor {
    switch (trail.level) {
      case 'Moderate':
        return const Color(0xFF023616);
      case 'Easy':
        return _HomeColors.mintText;
      default:
        return _HomeColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 288,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _HomeColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _AppImage(trail.image),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: _GlassPill(
                      child: Text(trail.level,
                          style: _t(11, FontWeight.w700,
                              color: _levelColor, spacing: 0.5)),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: _GlassPill(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              size: 12, color: _HomeColors.star),
                          const SizedBox(width: 4),
                          Text(trail.rating,
                              style: _t(11, FontWeight.w700, spacing: 0.5)),
                          const SizedBox(width: 4),
                          Text('(${trail.reviews})',
                              style: _t(11, FontWeight.w400,
                                  color: _HomeColors.textSoft, spacing: 0.5)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trail.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _t(16, FontWeight.w700, height: 24, spacing: 0.15)),
                const SizedBox(height: 2),
                Text(trail.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _t(11, FontWeight.w500,
                        color: _HomeColors.textSoft, spacing: 0.5)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            decoration: BoxDecoration(
              color: _HomeColors.surfaceLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _Stat('Distance', trail.distance),
                _Stat('Elev Gain', trail.elevation, color: _HomeColors.accent),
                _Stat('Duration', trail.duration),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Stat(this.label, this.value, {this.color = _HomeColors.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: _t(11, FontWeight.w500,
                  color: _HomeColors.textSoft, spacing: 0.5)),
          const SizedBox(height: 5),
          Text(value,
              style: _t(12, FontWeight.w700, color: color, spacing: 0.5)),
        ],
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  final Widget child;
  const _GlassPill({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xE6F8FAF6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Expedition card
// ---------------------------------------------------------------------------

class _ExpeditionCard extends StatelessWidget {
  final String image, badge, secondBadge, title, subtitle;
  final IconData badgeIcon, extraIcon;
  final bool badgeFilled;
  final List<String> tags;
  final String distance, duration, extra;
  final Color extraColor;
  final VoidCallback onLoad, onBookmark;

  const _ExpeditionCard({
    required this.image,
    required this.badge,
    required this.badgeIcon,
    required this.badgeFilled,
    required this.secondBadge,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.distance,
    required this.duration,
    required this.extraIcon,
    required this.extra,
    required this.extraColor,
    required this.onLoad,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _HomeColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero
          SizedBox(
            height: 208,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _AppImage(image),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xCC000000),
                        Color(0x4D000000),
                        Color(0x00000000),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  right: 12,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeFilled
                              ? _HomeColors.primary
                              : _HomeColors.mint,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(badgeIcon,
                                size: 13,
                                color: badgeFilled
                                    ? Colors.white
                                    : _HomeColors.mintText),
                            const SizedBox(width: 4),
                            Text(badge,
                                style: _t(11, FontWeight.w600,
                                    color: badgeFilled
                                        ? Colors.white
                                        : _HomeColors.mintText,
                                    spacing: 0.5)),
                          ],
                        ),
                      ),
                      _GlassPill(
                        child: Text(secondBadge,
                            style: _t(11, FontWeight.w600, spacing: 0.5)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title,
                          style: _t(20, FontWeight.w700,
                              color: Colors.white, height: 28)),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: _t(11, FontWeight.w500,
                              color: _HomeColors.chip, spacing: 0.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags
                      .map((t) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _HomeColors.chip,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(t,
                        style: _t(11, FontWeight.w500,
                            color: _HomeColors.textSoft,
                            spacing: 0.5)),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _HomeColors.surfaceLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Metric(Icons.straighten, distance),
                      const _VDivider(),
                      _Metric(Icons.calendar_month_outlined, duration),
                      const _VDivider(),
                      Flexible(
                        child: _Metric(extraIcon, extra,
                            color: extraColor, size: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: onLoad,
                          icon: const Icon(Icons.map_outlined, size: 18),
                          label: Text('Load Expedition GPX',
                              style: _t(12, FontWeight.w600,
                                  color: Colors.white, spacing: 0.5)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _HomeColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0.5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Material(
                        color: const Color(0xFFEDEEEB),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: onBookmark,
                          child: const Icon(Icons.bookmark_border,
                              size: 22, color: _HomeColors.textSoft),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final double size;
  const _Metric(this.icon, this.text,
      {this.color = _HomeColors.text, this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: _HomeColors.accent),
        const SizedBox(width: 8),
        Flexible(
          child: Text(text,
              style: _t(size, FontWeight.w700, color: color, spacing: 0.5)),
        ),
      ],
    );
  }
}

class _VDivider extends StatelessWidget {
  const _VDivider();
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 16, color: _HomeColors.divider);
}

// ---------------------------------------------------------------------------
// Image helper with graceful fallback
// ---------------------------------------------------------------------------

class _AppImage extends StatelessWidget {
  final String path;
  const _AppImage(this.path);

  Widget _fallback() => Container(
    color: _HomeColors.accent.withOpacity(0.35),
    child: const Icon(Icons.landscape, color: Colors.white70, size: 40),
  );

  @override
  Widget build(BuildContext context) {
    // Works with a web link ("https://...") or a bundled asset.
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : Container(
          color: _HomeColors.chip,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    return Image.asset(path,
        fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback());
  }
}