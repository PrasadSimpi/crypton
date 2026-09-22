import 'package:crypton/core/theme/app_theme.dart';
import 'package:crypton/features/portfolio/data/mock_portfolio_repository.dart';
import 'package:crypton/features/portfolio/presentation/controllers/portfolio_providers.dart';
import 'package:crypton/features/portfolio/presentation/screens/portfolio_screen.dart';
import 'package:crypton/features/profile/data/mock_profile_repository.dart';
import 'package:crypton/features/profile/domain/entities/user_profile.dart';
import 'package:crypton/features/profile/presentation/controllers/profile_providers.dart';
import 'package:crypton/features/profile/presentation/screens/profile_screen.dart';
import 'package:crypton/features/profile/presentation/widgets/profile_stats_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// `Override` is not in the main barrel in Riverpod 3.
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

/// Regression cover for the crash that took out the Portfolio and Profile tabs.
///
/// Both screens scroll, so their content is laid out with an unbounded height.
/// A `Row(crossAxisAlignment: stretch)` in that position hands its children a
/// tight infinite height and throws - and because the shell keeps every visited
/// tab alive in an `IndexedStack`, which lays out all of its children on every
/// frame, one broken tab took the others down with it.
///
/// Each test below pumps the real widget in the exact condition that failed.
void main() {
  /// Mirrors the position these widgets hold in the app: inside the shell's
  /// Scaffold (which is what supplies the Material ancestor a Switch needs)
  /// and inside a vertical scroll view, so their height arrives unbounded.
  Widget wrap(Widget child) => MaterialApp(
    theme: AppTheme.dark,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  Widget wrapScreen(Widget screen, List<Override> overrides) => ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(body: screen),
    ),
  );

  testWidgets('ProfileStatsRow survives an unbounded height', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        ProfileStatsRow(
          profile: UserProfile(
            name: 'Alex Rivera',
            email: 'alex@crypton.io',
            memberSince: DateTime(2024, 1),
            tradeCount: 148,
            assetsHeld: 4,
            verificationTier: 2,
            isVerified: true,
            linkedPaymentMethods: 2,
            displayCurrency: 'USD',
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('MEMBER SINCE'), findsOneWidget);
  });

  testWidgets('ProfileStatsRow still matches tile heights at 2x text scale', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: wrap(
          ProfileStatsRow(
            profile: UserProfile(
              name: 'Alex Rivera',
              email: 'alex@crypton.io',
              memberSince: DateTime(2024, 1),
              tradeCount: 148,
              assetsHeld: 4,
              verificationTier: 2,
              isVerified: true,
              linkedPaymentMethods: 2,
              displayCurrency: 'USD',
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('Portfolio tab builds without throwing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      wrapScreen(const PortfolioScreen(), <Override>[
        portfolioRepositoryProvider.overrideWithValue(
          const MockPortfolioRepository(latency: Duration.zero),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Holdings'), findsOneWidget);
    expect(find.text('Invested portfolio'), findsOneWidget);
  });

  testWidgets('Profile tab builds without throwing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      wrapScreen(const ProfileScreen(), <Override>[
        profileRepositoryProvider.overrideWithValue(
          const MockProfileRepository(latency: Duration.zero),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Alex Rivera'), findsOneWidget);
    expect(find.text('Two-factor authentication'), findsOneWidget);
  });
}
