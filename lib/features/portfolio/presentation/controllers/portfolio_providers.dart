import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/result.dart';
import '../../data/mock_portfolio_repository.dart';
import '../../domain/entities/holding.dart';
import '../../domain/entities/portfolio_summary.dart';
import '../../domain/portfolio_repository.dart';

final portfolioRepositoryProvider = Provider<PortfolioRepository>(
  (ref) => const MockPortfolioRepository(),
);

/// The user's book. Watched by the dashboard hero, the portfolio screen and the
/// position card on asset detail, so all three always show the same totals.
final portfolioProvider =
    AsyncNotifierProvider<PortfolioController, PortfolioSummary>(
      PortfolioController.new,
    );

final class PortfolioController extends AsyncNotifier<PortfolioSummary> {
  @override
  Future<PortfolioSummary> build() async =>
      (await ref.watch(portfolioRepositoryProvider).loadPortfolio()).unwrap();

  /// Re-fetch. Used by pull-to-refresh and by the error state's Retry button.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async =>
          (await ref.read(portfolioRepositoryProvider).loadPortfolio())
              .unwrap(),
    );
  }
}

/// The position in one asset, or null when the user holds none - including
/// while the book is still loading.
///
/// Derived from [portfolioProvider] rather than fetched again, so the asset
/// screen cannot show a position that disagrees with the portfolio screen.
final holdingProvider = Provider.family<Holding?, String>(
  (ref, symbol) => ref.watch(portfolioProvider).value?.holdingOf(symbol),
);
