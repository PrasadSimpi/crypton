import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// The four destinations in the shell.
enum AppTab {
  home(Icons.home_outlined, 'Home'),
  markets(Icons.trending_up_rounded, 'Markets'),
  portfolio(Icons.business_center_outlined, 'Portfolio'),
  profile(Icons.person_outline_rounded, 'Profile');

  const AppTab(this.icon, this.label);

  final IconData icon;

  /// Spoken by screen readers and used as the tooltip - the bar is icon-only.
  final String label;
}

/// The 264x64 pill that floats above the content (`.nav`).
///
/// Deliberately not a [NavigationBar]: neither it nor [BottomNavigationBar] can
/// detach from the bottom edge, and both impose their own height and surface.
/// The width is fixed at 264 so a tablet does not stretch it into a strip; the
/// caller aligns it.
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({
    required this.currentTab,
    required this.onSelected,
    super.key,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Container(
        width: 264,
        height: 64,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised.withValues(alpha: 0.96),
          borderRadius: AppRadii.pill,
          border: Border.all(color: AppColors.borderNav),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.55),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for (final tab in AppTab.values)
              _NavItem(
                tab: tab,
                isSelected: tab == currentTab,
                onTap: () => onSelected(tab),
              ),
          ],
        ),
      ),
    );
  }
}

/// One destination. Its own widget so selecting a tab repaints two items rather
/// than the whole bar.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final AppTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: tab.label,
      child: Tooltip(
        message: tab.label,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: AppSpacing.minTapTarget,
              height: AppSpacing.minTapTarget,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                tab.icon,
                size: 21,
                color: isSelected
                    ? AppColors.onAccent
                    : AppColors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
