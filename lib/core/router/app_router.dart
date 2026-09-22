import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/asset_detail/presentation/screens/asset_detail_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/markets/presentation/screens/markets_screen.dart';
import '../../features/portfolio/presentation/screens/portfolio_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/shell/presentation/screens/app_shell.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_routes.dart';

/// The root navigator. Asset detail is attached to it so it covers the shell,
/// replacing the floating nav with its own Buy/Sell bar.
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// The app's router, exposed as a provider so a test can override it.
///
/// Branch order here must match [AppTab.values] - the shell maps tab index to
/// branch index directly.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (BuildContext context, GoRouterState state) =>
            const SignInScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) => AppShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                builder: (BuildContext context, GoRouterState state) =>
                    const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.markets,
                builder: (BuildContext context, GoRouterState state) =>
                    const MarketsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.portfolio,
                builder: (BuildContext context, GoRouterState state) =>
                    const PortfolioScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.profile,
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.assetDetailPattern,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) =>
            AssetDetailScreen(
              symbol:
                  state.pathParameters[AppRoutes.symbolParam] ?? 'BTC',
            ),
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) =>
        _RouteNotFound(location: state.uri.toString()),
  );
});

/// Shown for an unknown deep link rather than a red error screen.
class _RouteNotFound extends StatelessWidget {
  const _RouteNotFound({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.explore_off_outlined,
                size: 30,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'We could not find $location.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: AppSpacing.xl),
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text('Go to dashboard', style: AppTextStyles.link),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
