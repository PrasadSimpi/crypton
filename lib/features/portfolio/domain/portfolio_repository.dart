import '../../../core/utils/result.dart';
import 'entities/portfolio_summary.dart';

/// Read access to the user's book.
abstract interface class PortfolioRepository {
  /// Every position plus the cross-book figures.
  Future<Result<PortfolioSummary>> loadPortfolio();
}
