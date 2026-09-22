# Crypton — Project Ledger

<!-- PROJECT LEDGER (iteration: 1) -->
```yaml
Active Architecture:
  State Management: Riverpod 3.4.3 — hand-written Notifier / AsyncNotifier, NO code-gen
  Navigation: go_router 18.0.1 — StatefulShellRoute.indexedStack, 4 branches
  Design Theme: Material 3, DARK ONLY (user decision), custom-skinned from the Crypton reference
  Backend/Data Layer: none — mock repositories behind domain interfaces, 380–900ms simulated latency
  Flutter/Dart: Flutter 3.47.x / Dart ^3.12.2 · targets Android + iOS, portrait phone only

Established Design Tokens:
  Colors (lib/core/theme/app_colors.dart):
    bg #0A0B0D · surface #111317 · surfaceRaised #17191E · surfaceChip #1B1E23 · surfaceField #14161A
    border #1D2025 · borderStrong #262A30 · borderNav #2A2E35 · divider #23262B
    accent #F2A93B · accentLight #FFC46B · accentDeep #C97F1F · onAccent #0A0B0D
    up #34C77B · upSoft #5BDD9C · down #F2555A · downText #FF7A7E
    textPrimary #F6F4F0 · textSecondary #A2A8B0 · textTertiary #868D96 · textQuaternary #6C727A
    coin tints: BTC #F2A93B · ETH #9AA6FF · SOL #3FD3CE · XRP #B4BECB (14% wash behind monograms)
  Spacing Scale: {xs:4, sm:8, md:12, lg:16, xl:20, xxl:24, xxxl:32}
    + gutter:20, card:18, tile:14, navReserve:118, actionBarReserve:108, minTapTarget:48
  Radii: {sm:14, md:18, lg:20, xl:24, xxl:28, pill:999} — AppRadii.* gives ready BorderRadius
  Typography: SpaceGrotesk (numbers/headings) + Manrope (body/labels), both bundled as static TTFs
    34 named styles in AppTextStyles, each carrying its default colour

Reusable Widget Registry (lib/shared/widgets/):
  - AppCard: bordered dark panel; padding/radius/colour/border all overridable
  - AppButton: primary | outline | subtle variants + isLoading + optional icon
  - AppIconButton: 44 circle inside a 48 tap target, optional unread badge
  - AppTextField: labelled 56-tall input, password reveal, icon+message error state
  - CoinAvatar: coin monogram chip; drops to one letter below 32px
  - UserAvatar: gradient initial disc, 44 and 64 variants
  - CoinRow: monogram + name + caller subtitle + optional sparkline + price/delta
  - CryptonMark: logo CustomPainter, stroke-on progress params, variable stroke weights
  - Sparkline: 56x24 normalised trend line
  - DeltaLabel: signed value + colour + optional direction arrow
  - MoneyText: whole part large / cents small, one baseline
  - SectionHeader: title + accent action or eyebrow
  - TimeframeSelector<T>: generic chip group, onAccent | grid variants
  - FloatingNavBar: 264x64 pill, 4 tabs (NOT NavigationBar — it cannot float)
  - BottomFade / AccentBloom / FadeUp: decorative, pointer- and semantics-free
  - AsyncView<T>: loading / empty / error+retry / data, keeps stale data during refresh
  - PageColumn: gutter + 560 max width + centred — the app's responsive rule

Screens / Features Implemented:
  - SplashScreen: / — done (3s staged animation, honours reduce-motion)
  - SignInScreen: /sign-in — done (+ Skip to guest)
  - DashboardScreen: /home — done
  - MarketsScreen: /markets — done (INFERRED, not in the 6 reference screens)
  - PortfolioScreen: /portfolio — done
  - ProfileScreen: /profile — done
  - AssetDetailScreen: /asset/:symbol — done (root navigator, covers the shell)
  - AppShell: 4-tab StatefulNavigationShell + floating nav — done

Key Package Dependencies:
  - flutter_riverpod ^3.4.3 — state
  - go_router ^18.0.1 — routing
  - flutter_lints ^6.0.0 — lints
  - (no google_fonts, no fl_chart, no freezed, no build_runner)

User Preferences Learned:
  - Portfolio / reel piece, not a store release — polish over infrastructure
  - Dark mode only; full files written straight into the project folder
  - Wants current 2026-era APIs, flagged when the brief is out of date
  - Prefers explanation over ceremony; minimal dependencies

Deliberate Deviations From The Brief:
  - No light theme (§1.5) — user asked for dark only; AppTheme is structured to add one
  - No ARB/i18n (§1.7) — user asked for English only; copy is centralised in widgets, not scattered
  - Riverpod 3 not 2.x — 2.x is superseded; StateProvider/StateNotifier are legacy imports now
  - Currency is USD, not INR — the supplied design quotes USD throughout and crypto is quoted in
    USD globally. One constant, Formatters.currencySymbol, switches it
  - Chart gridlines evenly spaced (10/98/186 of 196) rather than the reference's 10/103/186, so the
    hi / mid / lo axis labels land exactly on their lines
  - Timeframe chips are 44x44 tap targets, not 48 — the reference's own stated floor; everything
    else interactive is 48

Open TODOs / Known Tech Debt:
  - Buy / Sell / Send / Receive are affordances only — no order flow
  - Timeframe selectors change the chip state but not the series (one dataset per asset)
  - Profile toggles are in-memory; no settings persistence
  - Auth is a mock repository — any valid email + 6-char password passes
  - Non-BTC candles are synthesised from each coin's sparkline, not real OHLC
  - Volume bars are derived from body size, not traded volume (no volume in the fixtures)
  - flutter analyze has not been run — no Flutter SDK in this session (declined by user)
```
<!-- END LEDGER -->
