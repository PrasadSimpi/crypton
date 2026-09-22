/// Every route path in one place, so no screen builds a URL from a literal.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String signIn = '/sign-in';

  // Shell branches.
  static const String home = '/home';
  static const String markets = '/markets';
  static const String portfolio = '/portfolio';
  static const String profile = '/profile';

  /// Pattern registered with the router.
  static const String assetDetailPattern = '/asset/:symbol';

  /// Path parameter name used by [assetDetailPattern].
  static const String symbolParam = 'symbol';

  /// Concrete asset-detail location for [symbol].
  static String assetDetail(String symbol) =>
      '/asset/${symbol.toUpperCase()}';
}
