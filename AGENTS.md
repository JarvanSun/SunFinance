# AGENTS.md

SunFinance is an iOS paper-trading app (watchlist, charts, portfolio and scheduled orders for one
demo account) that shows how a production SwiftUI codebase is structured; it runs entirely on a
mock backend and is not shipped to the App Store.

## Before writing code

Read [docs/spec/README.md](docs/spec/README.md) and the files it lists, starting with
`product.md`. The spec is binding: when code and spec disagree, the code is wrong, or the spec
changes in the same change. `Features/Watchlist` is the reference feature; copy its shape.

## Commands

- Open `SunFinance.xcodeproj`. Signing reads the Apple team ID from
  `Configuration/Signing.local.xcconfig` (untracked; `DEVELOPMENT_TEAM = <team id>`).
- `scripts/format.sh` after editing Swift; `scripts/format.sh --lint` must succeed.
- Build and test:
  `xcodebuild test -scheme SunFinance -destination 'platform=iOS Simulator,name=iPhone 17'`.
- One package on its own: the same command with `-scheme <Package>`, run in the package's folder.
- Each package's `Playground/Playground.xcodeproj` is an app that runs the package without the
  App.

## Hard rules

- iOS 18 minimum, Swift 6 language mode, SwiftUI and Observation only.
- Feature packages live in `Features/`, DesignSystem and FinanceCore in `Core/`. Features never
  import each other; FinanceCore's domains (`MarketData/`, `Brokerage/`) never use each other's
  types ([architecture.md](docs/spec/architecture.md#modules)).
- Every package builds, tests and previews on its own, opened without the App.
- No App Store review prompt, no remote backend or push, no real third-party SDK.
- Shared foundation is SunKit (`SunCore`, `SunUserInterface`) 0.2.x, at least 0.2.2; app-specific
  code never goes into it.
- No `static` except protocol requirements, leading-dot extensions of protocol-typed SwiftUI and
  Foundation APIs, and `VendorAnalytics.shared`; localization keys are written where they are used
  ([swift-style.md](docs/spec/swift-style.md#no-static)).
- No explanatory comments; `// MARK: -` only above the extensions of files over 150 lines
  ([swift-style.md](docs/spec/swift-style.md#comments)).
