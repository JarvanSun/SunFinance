# Architecture

Everything comes from a mock server that behaves like a real backend (latency, failures, paging,
idempotent writes, an exchange that fills orders); nothing in the UI or the ViewModels knows it is
a mock.

- iOS 18 or later, iPhone only, portrait and landscape.
- Swift 6 language mode, Swift tools 6.2, Xcode 26. SwiftUI and Observation only.
- MVVM per feature, features as local Swift packages.
- No App Store review prompt, no in-app purchase, no remote push.

## Modules

```text
SunFinance                   App target: composition root, tabs, privacy shield
├── Features/
│   ├── Watchlist            quotes, search, favorites
│   ├── Instrument           quote detail and the order ticket it opens
│   ├── Orders               open and past orders, fills, cancelling
│   └── Portfolio            positions, performance chart, allocation
├── Core/DesignSystem        every visual decision, shared components, motion, charts
├── Core/FinanceCore         everything below the interface:
│   ├── Values/              TickerSymbol, Money, CurrencyCode, Page, HistoryRange, TradeIntent
│   ├── Networking/          server environments, the client, HTTP names
│   ├── MockServer/          the mock server, the mock exchange, each domain's routes and engine
│   ├── MarketData/          quotes, price history, symbol search, watchlist and favorites stores
│   ├── Brokerage/           account, positions, portfolio history, orders
│   └── Analytics/           event model, tracking pipeline, vendor adapter
│   (VendorAnalyticsSDK: a second target, the fake vendor SDK)
└── SunKit                   SunCore, SunUserInterface: transport, routing, styling protocols
```

| Module | May import | Never imports |
|---|---|---|
| App | every package | — |
| A feature | DesignSystem, FinanceCore, SunUserInterface: only those it uses | another feature |
| DesignSystem | FinanceCore (its values only), SunUserInterface, Charts | any feature |
| FinanceCore | SunCore; VendorAnalyticsSDK (only in `VendorAnalyticsDestination`) | SwiftUI, other packages |
| VendorAnalyticsSDK | Foundation | everything else |

A dependency not in this table is not allowed; adding one changes the table first.

- Features see only FinanceCore's public surface
  ([networking.md](networking.md#public-and-internal)).
- Inside FinanceCore, `MarketData/` and `Brokerage/` never use each other's types, and
  `Analytics/` uses neither. A value two of them need lives in `Values/`: values and validation
  only, no I/O, no display formatting. Only `MockServer/` reaches across domains.
- Feature packages are named after the feature without a suffix (`Watchlist`). Each package has
  one library product named after it and one test target, `<Package>Tests`.

## Every package runs on its own

Opening a package's `Package.swift` with the App closed builds it, runs its tests and renders every
preview.

- A package declares every dependency in its own `Package.swift`: siblings by relative path, SunKit
  by URL.
- A package never reads the App's bundle, catalog, assets, Info.plist or configuration; what it
  needs arrives through its `*Dependencies` or an initializer.
- `<Name>HostView.swift` ends with a preview built from `PreviewObjectPool.<name>Dependencies()`,
  where every `FeatureEntry` is a stand-in screen, so the canvas runs the whole flow.
- Every package also runs as an app: `Playground/project.yml` generates `Playground.xcodeproj` with
  one target, `<Package>Playground`, from the template in `scripts/playground-base.yml`. Feature
  playgrounds run the `*HostView` on the mock backend; DesignSystem's is a catalogue of tokens,
  components, motion and charts; FinanceCore's is a console for the exchange, each provider and
  analytics.
- A playground uses only the package's `public` API and English `Text(verbatim:)`. It has no tests;
  logic worth testing belongs in the package.

## Isolation

| Module | Default isolation |
|---|---|
| App, features, DesignSystem | `MainActor` |
| FinanceCore | nonisolated; every public value and service is `Sendable` |
| VendorAnalyticsSDK | `MainActor`, as vendor SDKs expect |

- MainActor packages set `.defaultIsolation(MainActor.self)`, `NonisolatedNonsendingByDefault` and
  `InferIsolatedConformances`; the App sets `SWIFT_DEFAULT_ACTOR_ISOLATION` and
  `SWIFT_APPROACHABLE_CONCURRENCY`.
- Every module enables `MemberImportVisibility`, so each file imports exactly what it uses.
- In a MainActor module, write no isolation keyword. `nonisolated` goes only on the narrowest
  declaration the compiler reports as used off the main actor (a `Shape`, a `FeatureDestination`,
  formatting called from `@Sendable` closures, fixtures for `@Test(arguments:)`). Members in an
  extension do not inherit the type's `nonisolated`.
- In FinanceCore, `@MainActor` marks only what the UI calls synchronously: the watchlist and
  favorites stores and the analytics protocols and classes, not the analytics values. Their tests
  mark the test struct `@MainActor`.
- An async service protocol (`QuoteProviding`) is nonisolated and `Sendable`; its fake is a
  `struct`.
- Work that must leave the main actor is `@concurrent` or lives in an `actor`.

## A feature from the outside

A feature exposes exactly two public types per entry the App shows:

```swift
public struct WatchlistDependencies { ... }   // what the App injects
public struct WatchlistHostView: View { ... } // the only view the App can show
```

Instrument has two entries: quote detail (`QuoteDetailDependencies`, `QuoteDetailHostView`) and
the order ticket (`TradingDependencies`, `TradingHostView`). Everything else is `internal`.

The public host forwards to an internal `<Name>NavigationHost: FeatureHost`, because SunKit's
`FeatureHost` would otherwise force the router to be public. It owns the router and the root
ViewModel with `@State`; `dependencies.makeViewModel(router:)` (internal) unpacks the dependencies
into the ViewModel's initializer.

## Navigation

SunKit routing: `FeatureDestination` → `FeatureRouting` router → `FeatureDestinationView` →
`FeatureHost`, in `Navigation/` (`<Name>Dependencies`, `Destination`, `Router`, `DestinationView`,
`Routing`, `NavigationHost`).

- ViewModels navigate through a feature-local protocol (`WatchlistRouting`) that speaks in intents
  (`showQuoteDetail(for:)`), not destinations or paths.
- A flow pushed onto another stack (quote detail) sets `addContentInNavigationView` to `false`; its
  router still presents its own sheets. A router that reports a closed sheet takes the closure
  with the intent (`showOrderTicket(for:onDismiss:)`).
- Inside a package, flows open each other directly: quote detail presents `TradingHostView` with
  `QuoteDetailDependencies.orderTicket(for:)`, built from a closure the App passes in once.
- Across features, a feature receives the other screen as a `FeatureEntry<Input>` in its
  dependencies (`let quoteDetail: FeatureEntry<TickerSymbol>`). `FeatureEntry` lives in
  DesignSystem and is the only place `AnyView` is allowed.

## The App

`SunFinance/` holds `App/` (`SunFinanceApp`, `AppRoot`), `Composition/` (`AppDependencies`,
`AppConfiguration`), `Navigation/` (`MainTabsView`, `AppTab`), `Localization/` (`AppText`) and
`Resources/`; `SunFinanceTests/` mirrors it. The root shows a `TabView` at once, each tab a
feature's `*HostView` with its own stack, under the privacy shield.

`SunFinanceApp` creates one `AppDependencies` from `AppConfiguration.demo`. It builds one
`ServerEnvironment.mock(behavior:storageDirectory:)` for both services, so every screen sees the
same exchange and account, and builds each feature's dependencies and the `FeatureEntry`s between
them in instance methods (`watchlist()`, `quoteDetail(for:)`, `trading(for:)`…).

- No singletons, `shared` instances, service locators or `enum`s of `static` factories.
- Configuration is a value, read only by the composition root and passed down.

## Inside a feature

Folders follow the screens: the public hosts are the only files at the top, each screen is a
folder nested the way screens are pushed, and what spans the feature has its own folder.

```text
Features/Watchlist/
├── Package.swift
├── Sources/Watchlist/
│   ├── WatchlistHostView.swift
│   ├── Navigation/
│   ├── Screens/Watchlist/          # one folder per screen
│   │   ├── WatchlistView.swift
│   │   ├── WatchlistViewModel.swift
│   │   ├── Model/                  # state values: activity, placeholder, issue, sort order
│   │   ├── Presentation/           # titles, symbols, colors, accessibility text for them
│   │   ├── Views/                  # rows, sections, toolbar of this screen
│   │   └── <Pushed>/               # a screen pushed from this one, same shape
│   ├── Analytics/  Accessibility/  Extensions/  Resources/
│   └── Preview Content/            # PreviewObjectPool, preview fakes (DEBUG only)
├── Tests/                          # mirrors Sources/Watchlist, plus Fakes/
└── Playground/
```

- A package with two flows (Instrument) keeps one of each feature-wide folder; what both flows'
  screens share sits in `Screens/Model/` and `Screens/Presentation/`.
- Something used by two screens moves up to the closest folder both share; a view used by two
  features moves to DesignSystem; a helper used by two packages moves down to the lowest package
  both depend on.
- Tests sit directly in `Tests/`; `Sources/` keeps a folder per target (FinanceCore has two).
- A folder exists only once it has a file. No `Shared/`, `Helpers/`, `Utils/`, `Common/` or
  `Managers/`.
