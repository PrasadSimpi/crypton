import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

/// The standard page body: gutter padding, a readable maximum width, centred.
///
/// This is where the app's responsive behaviour lives. Phone layouts are
/// unaffected; on a tablet or a desktop window the content stops widening
/// instead of stretching a 390-wide design across 1200 pixels.
class PageColumn extends StatelessWidget {
  const PageColumn({
    required this.children,
    super.key,
    this.maxWidth = 560,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final List<Widget> children;
  final double maxWidth;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          ),
        ),
      ),
    );
  }
}
