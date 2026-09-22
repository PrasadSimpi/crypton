import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/user_avatar.dart';

/// Dashboard top bar: who you are on the left, search and alerts on the right.
class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({
    required this.name,
    required this.initial,
    super.key,
    this.onSearch,
    this.onNotifications,
    this.hasUnread = true,
  });

  final String name;
  final String initial;
  final VoidCallback? onSearch;
  final VoidCallback? onNotifications;
  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        UserAvatar(initial: initial),
        const SizedBox(width: AppSpacing.md - 1),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'PORTFOLIO',
                style: AppTextStyles.subtleBold.copyWith(letterSpacing: 0.8),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: AppTextStyles.rowTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        AppIconButton(
          icon: Icons.search_rounded,
          semanticLabel: 'Search markets',
          onPressed: onSearch,
        ),
        const SizedBox(width: AppSpacing.sm - 2),
        AppIconButton(
          icon: Icons.notifications_none_rounded,
          semanticLabel: hasUnread
              ? 'Notifications, unread'
              : 'Notifications',
          showBadge: hasUnread,
          onPressed: onNotifications,
        ),
      ],
    );
  }
}
