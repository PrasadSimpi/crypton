import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// The application root.
///
/// Dark-only by product decision: the reference is amber on near-black, and a
/// light inversion would be a different design rather than a tint. Both theme
/// slots are filled with the same scheme so nothing can fall through to
/// Material's defaults if the platform reports light.
class CryptonApp extends ConsumerWidget {
  const CryptonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Crypton',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(routerProvider),
      builder: (BuildContext context, Widget? child) {
        // One place to own the status-bar styling: none of the screens use an
        // AppBar, so there is nothing else setting it.
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppTheme.overlayStyle,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
