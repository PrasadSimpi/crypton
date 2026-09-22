import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Which surface the selector sits on.
enum TimeframeSelectorVariant {
  /// A loose row on the amber hero card (`.tf-row`).
  onAccent,

  /// An equal-width grid on the dark asset screen (`.tf-grid`).
  grid,
}

/// The 1D / 1W / 1M chip group, generic over whatever enum drives it.
///
/// One widget, two treatments: the dashboard and the asset screen differ only
/// in [variant], so a change to chip geometry lands in both at once.
class TimeframeSelector<T> extends StatelessWidget {
  const TimeframeSelector({
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    super.key,
    this.variant = TimeframeSelectorVariant.onAccent,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onSelected;
  final TimeframeSelectorVariant variant;

  @override
  Widget build(BuildContext context) {
    final isGrid = variant == TimeframeSelectorVariant.grid;
    final gap = isGrid ? AppSpacing.xs : AppSpacing.xs + 2;

    final chips = <Widget>[
      for (var i = 0; i < values.length; i++) ...<Widget>[
        if (i > 0) SizedBox(width: gap),
        if (isGrid)
          Expanded(child: _chip(values[i]))
        else
          _chip(values[i]),
      ],
    ];

    return Row(
      mainAxisSize: isGrid ? MainAxisSize.max : MainAxisSize.min,
      children: chips,
    );
  }

  Widget _chip(T value) {
    final isSelected = value == selected;
    final isGrid = variant == TimeframeSelectorVariant.grid;

    final background = isSelected
        ? (isGrid ? AppColors.accent : AppColors.onAccent)
        : Colors.transparent;
    final foreground = isSelected
        ? (isGrid ? AppColors.onAccent : AppColors.accentLight)
        : (isGrid
              ? AppColors.textTertiary
              : AppColors.onAccent.withValues(alpha: 0.70));

    return _TimeframeChip(
      label: labelOf(value),
      isSelected: isSelected,
      background: background,
      foreground: foreground,
      expand: isGrid,
      onTap: () => onSelected(value),
    );
  }
}

/// Pulled out so each chip gets its own rebuild scope and a `const`-able shape.
class _TimeframeChip extends StatelessWidget {
  const _TimeframeChip({
    required this.label,
    required this.isSelected,
    required this.background,
    required this.foreground,
    required this.expand,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color background;
  final Color foreground;
  final bool expand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.pill,
          // 44 square is the floor the reference holds itself to; the painted
          // pill stays shorter so the row keeps its designed rhythm.
          child: SizedBox(
            height: 44,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                height: expand ? 44 : 30,
                width: expand ? double.infinity : null,
                alignment: Alignment.center,
                padding: expand
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: AppRadii.pill,
                ),
                child: Text(
                  label,
                  style: AppTextStyles.tab.copyWith(
                    color: foreground,
                    fontWeight:
                        isSelected && expand ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
