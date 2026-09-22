import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bottom_fade.dart';
import '../../../../shared/widgets/floating_nav_bar.dart';

/// Hosts the four tab branches and paints the floating nav over them.
///
/// Uses [StatefulNavigationShell], so each branch keeps its own scroll position
/// and navigation stack when the user moves between tabs.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onTabSelected(AppTab tab) {
    // Re-tapping the current tab pops that branch back to its root, which is
    // the behaviour every tabbed app has trained people to expect.
    navigationShell.goBranch(
      tab.index,
      initialLocation: tab.index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = AppTab.values[navigationShell.currentIndex];

    return Scaffold(
      backgroundColor: AppColors.bg,
      // The nav floats over the content, so the body must extend under it and
      // each screen reserves AppSpacing.navReserve at its foot.
      body: Stack(
        children: <Widget>[
          navigationShell,
          const Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(child: BottomFade()),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: FloatingNavBar(
                currentTab: currentTab,
                onSelected: _onTabSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
