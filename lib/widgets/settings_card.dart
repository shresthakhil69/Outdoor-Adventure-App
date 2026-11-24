import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// White rounded card that stacks its children with dividers in between.
class SettingsCard extends StatelessWidget {
  const SettingsCard({
    super.key,
    required this.children,
    this.insetDividers = false,
  });

  final List<Widget> children;

  /// true  -> divider has 16px space on both sides
  /// false -> divider goes edge to edge
  final bool insetDividers;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        items.add(Divider(
          height: 1,
          thickness: 1,
          color: AppColors.divider,
          indent: insetDividers ? 16 : 0,
          endIndent: insetDividers ? 16 : 0,
        ));
      }
      items.add(children[i]);
    }

    final radius = BorderRadius.circular(16);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A191C1A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: double.infinity,
          child: Column(children: items),
        ),
      ),
    );
  }
}
