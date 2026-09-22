# Crypton

A dark-theme crypto trading UI built in Flutter from the Crypton design
reference. Six screens, every figure mock, no backend.

## Running it

```bash
flutter pub get
flutter run
```

Fonts are bundled under `assets/fonts/`, so the app renders identically
offline and never flashes a fallback face - which matters when the screens are
being screen-recorded.

## Screens

| Route | Screen |
| --- | --- |
| `/` | Splash - the mark strokes itself on over three seconds |
| `/sign-in` | Sign in, with Skip to enter as a guest |
| `/home` | Dashboard - balance, 24h move, quick actions, watchlist |
| `/markets` | Markets - search and sort the asset list |
| `/portfolio` | Invested portfolio - totals, allocation, P&L, holdings |
| `/profile` | Profile and settings |
| `/asset/:symbol` | Asset detail - candles, volume, stats, your position |

## Architecture

Feature-first clean architecture. Each feature owns its own `data/`,
`domain/` and `presentation/` and can be deleted without touching the others.

```
lib/
├── core/        theme tokens, router, errors, formatting
├── shared/      cross-feature widgets
└── features/
    ├── splash/ auth/ dashboard/ markets/
    ├── portfolio/ asset_detail/ profile/
    ├── market/      coins, candles, market stats
    └── shell/       the four-tab scaffold
```

- **State**: Riverpod 3, hand-written `Notifier` / `AsyncNotifier`. No
  code generation, so there is no `build_runner` step.
- **Navigation**: go_router with `StatefulShellRoute.indexedStack`, so each tab
  keeps its own stack and scroll position.
- **Charts**: `CustomPainter` throughout - the area curve, the candlesticks, the
  volume strip, the sparklines and the logo mark. No charting package.
- **Errors**: repositories return `Result<T>`; providers turn a `Failure` into
  `AsyncValue.error`; `AsyncView` renders loading, empty and error states.

## The numbers

Only primitive facts are stored: quantities, average costs, live prices, and
the 22 real BTC bars. Market value, cost basis, profit, allocation percentages,
market cap, 24h high/low and the 7-day change are all derived, so no two
figures on screen can disagree.

## Tests

```bash
flutter test
```

Covers the formatting helpers, the portfolio maths, and a smoke test that the
splash hands over to sign-in.

## Known gaps

Buy, Sell, Send and Receive are affordances only. Settings toggles are
in-memory. There is no backend, no persistence and no real auth - the mock
repository accepts any well-formed email with a six-character password.
