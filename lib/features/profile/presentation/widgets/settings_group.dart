import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A bordered group of settings rows with hairlines between them.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: <Widget>[
          for (var i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0)
              const Divider(height: 1, color: AppColors.surfaceChip),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// One settings row: icon chip, label, optional meta or trailing control.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.title,
    super.key,
    this.meta,
    this.metaIsPositive = false,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;

  /// Right-aligned detail text, e.g. `2 linked`.
  final String? meta;

  /// Renders [meta] in the gain colour, for states like `Complete`.
  final bool metaIsPositive;

  /// A control such as a switch. Replaces the chevron.
  final Widget? trailing;

  final VoidCallback? onTap;

  /// Log out and the like: red label and a tinted icon chip.
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final tint = isDestructive ? AppColors.downText : const Color(0xFFC3C9D1);

    final row = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.tile,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDestructive
                  ? AppColors.down.withValues(alpha: 0.12)
                  : AppColors.surfaceChip,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: tint),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.settingTitle.copyWith(
                color: isDestructive
                    ? AppColors.downText
                    : AppColors.textPrimary,
                fontWeight: isDestructive
                    ? FontWeight.w700
                    : FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (meta != null) ...<Widget>[
            const SizedBox(width: AppSpacing.sm),
            Text(
              meta!,
              style: AppTextStyles.captionBold.copyWith(
                color: metaIsPositive
                    ? AppColors.up
                    : AppColors.textTertiary,
                fontWeight: metaIsPositive
                    ? FontWeight.w700
                    : FontWeight.w600,
              ),
            ),
          ],
          if (trailing != null) ...<Widget>[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ] else if (onTap != null) ...<Widget>[
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textQuaternary,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: row,
      );
    }

    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.minTapTarget + 4,
            ),
            child: row,
          ),
        ),
      ),
    );
  }
}
