import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// "S15 Safety Hub" bar at the top of every screens.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      shadowColor: const Color(0x14000000),
      elevation: 1,
      scrolledUnderElevation: 1,
      toolbarHeight: 56,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x401E4D2B),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.terrain, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('S15 Safety Hub', style: AppTextStyles.appTitle),
                Text('Yak & Trail • Nepal Himalaya',
                    style: AppTextStyles.labelSmall),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.satellite_alt,
                size: 20, color: AppColors.onSurfaceVariant),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.darkGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
