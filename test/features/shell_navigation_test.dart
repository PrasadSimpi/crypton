import 'package:crypton/app.dart';
import 'package:crypton/shared/widgets/floating_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Drives the real app the way a person does - splash, skip sign-in, then tap
/// every tab - because that is the only place the bug reproduced.
///
/// The shell keeps every visited tab alive in an `IndexedStack`, which lays out
/// all of its children on every frame. A single tab that threw during layout
/// therefore took the whole shell down, and the app looked frozen rather than
/// crashed. A test that pumps one screen on its own cannot see that; this one
/// visits the tabs twice so each is exercised both on first build and while the
/// others are already mounted.
void main() {
  Future<void> bootToHome(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: CryptonApp()));
    // The splash runs for three seconds before it routes on.
    await tester.pump(const Duration(milliseconds: 3200));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
  }

  /// Every tab, twice round, so each one is built cold and then re-laid out
  /// alongside its siblings.
  const visits = <AppTab>[
    AppTab.markets,
    AppTab.portfolio,
    AppTab.profile,
    AppTab.home,
    AppTab.markets,
    AppTab.portfolio,
    AppTab.profile,
  ];

  // Phone first - the design target - then the window sizes the desktop and
  // web builds actually open at.
  const sizes = <Size>[
    Size(390, 844),
    Size(430, 932),
    Size(800, 600),
    Size(1280, 720),
  ];

  for (final size in sizes) {
    testWidgets(
      'every tab opens without throwing at ${size.width.toInt()}x'
      '${size.height.toInt()}',
      (WidgetTester tester) async {
        await bootToHome(tester, size);
        expect(tester.takeException(), isNull, reason: 'Home');

        for (final tab in visits) {
          await tester.tap(find.byTooltip(tab.label));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: tab.label);
        }
      },
    );
  }

  testWidgets('each tab lands on its own route', (WidgetTester tester) async {
    await bootToHome(tester, const Size(390, 844));

    for (final tab in AppTab.values) {
      await tester.tap(find.byTooltip(tab.label));
      await tester.pumpAndSettle();
      expect(find.byTooltip(tab.label), findsOneWidget);
    }

    // The Markets tab is the one with no reference screen behind it, so assert
    // it actually rendered its list rather than an empty or error state.
    await tester.tap(find.byTooltip(AppTab.markets.label));
    await tester.pumpAndSettle();
    expect(find.text('Markets'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);

    await tester.tap(find.byTooltip(AppTab.profile.label));
    await tester.pumpAndSettle();
    expect(find.text('Alex Rivera'), findsOneWidget);
    expect(find.text('Two-factor authentication'), findsOneWidget);
  });
}
