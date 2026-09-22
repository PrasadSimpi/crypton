import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/async_view.dart';
import '../../../../shared/widgets/page_column.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../domain/entities/portfolio_summary.dart';
import '../controllers/portfolio_providers.dart';
import '../widgets/allocation_card.dart';
import '../widgets/holding_row.dart';
import '../widgets/pnl_mini_card.dart';
import '../widgets/portfolio_summary_card.dart';

/// The invested-portfolio screen: totals, allocation, P&L, and every position.
class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(portfolioProvider);

    return RefreshIndicator(
      onRefresh: ref.read(portfolioProvider.notifier).refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          bottom: false,
          child: PageColumn(
            children: <Widget>[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: <Widget>[
                  AppIconButton(
                    icon: Icons.chevron_left_rounded,
                    semanticLabel: 'Back',
                    onPressed: () => context.go(AppRoutes.home),
                  ),
                  Expanded(
                    child: Text(
                      'Invested portfolio',
                      style: AppTextStyles.titleLarge,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AppIconButton(
                    icon: Icons.tune_rounded,
                    semanticLabel: 'Filter holdings',
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.card),
              AsyncView<PortfolioSummary>(
                value: portfolio,
                loadingHeight: 420,
                onRetry: ref.read(portfolioProvider.notifier).refresh,
                isEmpty: (PortfolioSummary data) => data.holdings.isEmpty,
                emptyMessage: 'You have no open positions yet.',
                builder: (PortfolioSummary data) => _PortfolioBody(data: data),
              ),
              const SizedBox(height: AppSpacing.navReserve),
            ],
          ),
        ),
      ),
    );
  }
}

class _PortfolioBody extends StatelessWidget {
  const _PortfolioBody({required this.data});

  final PortfolioSummary data;

  @override
  Widget build(BuildContext context) {
    final holdings = data.byValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PortfolioSummaryCard(
          currentValue: data.totalValue,
          totalInvested: data.totalInvested,
          profit: data.unrealisedPnl,
          profitPercent: data.unrealisedPnlPercent,
        ),
        const SizedBox(height: AppSpacing.tile),
        AllocationCard(portfolio: data),
        const SizedBox(height: AppSpacing.md),
        // IntrinsicHeight bounds the row before stretch is applied. Without it
        // the row inherits an unbounded height from the scroll view and hands
        // its children a tight infinite height, which throws.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: PnlMiniCard(
                  label: 'REALISED P&L',
                  amount: data.realisedPnl,
                  note: 'Booked - ${data.realisedExits} exits',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PnlMiniCard(
                  label: 'UNREALISED P&L',
                  amount: data.unrealisedPnl,
                  note: 'Open - ${data.assetCount} positions',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.card),
        const SectionHeader(title: 'Holdings', trailingLabel: 'BY VALUE'),
        const SizedBox(height: AppSpacing.md),
        for (var i = 0; i < holdings.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          HoldingRow(
            holding: holdings[i],
            onTap: () =>
                context.push(AppRoutes.assetDetail(holdings[i].symbol)),
          ),
        ],
      ],
    );
  }
}
