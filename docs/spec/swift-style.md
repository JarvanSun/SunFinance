# Swift Style

Code reads top to bottom like prose: every name says what a thing is, every function does one
thing, and nothing needs a comment.

## Formatting

Layout a tool can decide is fixed in `.swift-format` and applied by `scripts/format.sh`;
`scripts/format.sh --lint` must succeed.

- 4-space indentation, 100 columns.
- A comma-separated list (arguments, parameters, array literals, generic requirements) fits on one
  line, or every element goes on its own line, the first one included. Never mix.
- One blank line between declaration groups, between top-level sections of a `body`, and after a
  `guard`. Never two blank lines in a row.
- `#if DEBUG` blocks are not indented.
- When the type is known from context, write `.init(...)` instead of repeating the type name
  ([details](#init-from-context)).

## Files

- Every Swift file starts with the Xcode header: file name, module name, `Created by <author> on
  <yyyy/MM/dd>.`; the date never changes. In `Package.swift` the header follows
  `// swift-tools-version:`.
- One top-level type per file, named after the type. A `private` helper type used only by the
  file's main type may stay in that file.
- An extension of a type from another module goes in `<Type>Extensions.swift`
  (`StringExtensions.swift`), never `String+Blank.swift`.
- Presentation of a model (titles, symbols, colors, accessibility text) goes in
  `<Type>Presentation.swift` (`StockQuotePresentation.swift`).
- Any other extension of our own type in its own file is named after what it adds
  (`StockQuoteMatching.swift`).
- Dummy data for a type goes in `<Type>Dummy.swift` (`StockQuoteDummy.swift`,
  `TickerSymbolDummy.swift`), whichever module the type comes from
  ([Dummy data](#dummy-data)).
- Nothing lives at file level except types and their extensions: every `func`, `let` and `var`
  belongs to a type. A helper goes in the file's trailing `private extension <Type>`, in an
  extension of the value type it works on (`private extension AppConfiguration { var
  analyticsTracker: AnalyticsTracker }`), or in a small `private` helper type. The only exception
  is a `Package.swift` manifest.

## Naming

| Kind | Rule | Good | Bad |
|---|---|---|---|
| Type | Noun phrase for what it is | `StockQuote`, `PriceHistory` | `QuoteData`, `QuoteManager` |
| Capability protocol | `-ing` | `QuoteProviding`, `AnalyticsTracking` | `QuoteProviderProtocol` |
| Boolean | `is` / `has` / `can` / `should` | `isFavorite`, `hasRows` | `favorite`, `newsFlag` |
| Intent method | Verb phrase the user would say | `refresh()`, `toggleFavorite(_:)` | `handleTap()`, `didPress()` |
| Query method | Noun phrase or `is…(_:)` | `isFavorite(_:)`, `favoriteAction(for:)` | `getFavorite(_:)` |
| Closure property | What happens | `onRetry`, `onSelect` | `callback`, `handler` |
| Test fake | Role suffix | `QuoteProviderStub`, `AnalyticsTrackerSpy` | `MockStuff`, `TestHelper` |

- No abbreviations except `ID`, `URL`, `API`, `DTO`, `JSON`, `HTTP`: `quote`, not `q`;
  `viewModel`, not `vm`.
- Never `data`, `info`, `item`, `object`, `value`, `manager`, `helper`, `handle` or `util` as a
  whole name; as a suffix only in a domain phrase (`QuotesResponseDTO`).
- Do not repeat the type in member names: `quote.symbol`, not `quote.quoteSymbol`.
- Name a value after what it means: `fetchedQuotes` while it is a fetch result, `visibleQuotes`
  once filtered.

## Declaration order

Inside a type, one blank line between groups; inside a group, the order in which the screen or
caller uses them. [The Watchlist ViewModel](view-model.md#reference-implementation) follows it.

1. Nested types (small `private` ones only; anything bigger gets its own file).
2. `@Environment`, `@State`, `@Binding` properties (views).
3. Observable stored state: `private(set) var`.
4. Bindable stored state: `var` a view writes through `@Bindable`.
5. Derived state: computed `var`.
6. Dependencies: `private let`.
7. Private stored state: `private var`.
8. Initializers.
9. `body` (views).
10. Intents, in the order the user meets them.
11. Queries.
12. A trailing `private extension <Type>` with private computed properties and steps, in call
    order.

### Section marks

A file under 150 lines has no `// MARK:`. A longer file puts one `// MARK: - <Name>` directly
above each top-level extension, followed by one blank line:

| Extension | Name |
|---|---|
| The trailing `private extension` of the file's type | `Private` |
| A conformance (`extension X: Equatable`) | The protocol: `Equatable` |
| Another extension of the file's type | What it groups: `Sections`, `Trading` |
| An extension of another type | That type: `Decimal`, `OrderTrigger` |
| The `#if DEBUG` block with the previews | `Previews` |

The type's own declaration has no mark; marks never appear inside a type, a function or a test
file.

## Access control

- Default is `internal`, written without a modifier.
- `public` only on what another module uses: a feature's `*HostView` and `*Dependencies`; a Core
  package's protocols, models, styles and components.
- Members used only in the file are `private`; `fileprivate` only when a second type in the file
  needs the member.
- Classes are `final`.
- A `public` type writes out a `public` initializer; the memberwise one is never relied on across
  modules.
- Tests use `@testable import`. Never widen access for a test.

## Functions

- One responsibility: if describing a function needs "and", split it.
- The top function reads like a table of contents of well-named private steps
  ([example](view-model.md#async-loading)).
- A function that does not fit on one screen, or nests more than two levels, is split.
- At most four parameters; more means a value type is missing.
- A protocol type is written bare, as a parameter and as a stored property:
  `quoteProvider: QuoteProviding`, `private let quoteProvider: QuoteProviding`. The project does
  not enable `ExistentialAny`, so `any` and `some` appear only where the compiler needs them: a
  protocol with an associated or primary associated type (`clock: some Clock<Duration>`, stored as
  `any Clock<Duration>`), an opaque result (`some View`, `some AxisContent`), or a generic use that
  needs it.

### `.init` from context

Write `.init(…)` when the surrounding declaration already states the type:

- the single-expression body of a function or computed property, or a `return`, of that type;
- each value of a `switch` that is such a body;
- a property, a parameter default or a `let` with an explicit type annotation;
- an enum payload and an element of a collection literal whose element type is stated.

```swift
func watchlist() -> WatchlistDependencies {
    .init(
        watchlistStore: watchlistStore,
        quoteProvider: marketData,
        symbolSearcher: marketData,
        favoriteStore: favoriteStore,
        clock: ContinuousClock(),
        tracker: tracker,
        quoteDetail: quoteDetailEntry
    )
}
```

Keep the type name where nothing nearby states it (`let environment = ServerEnvironment(…)`), for
a SwiftUI view built inside a `body` or `@ViewBuilder`, and where `.init` would be ambiguous
(`String(localized:)`). A presentation `switch` that produces a `LocalizedStringResource` writes
every case as `.init("key", bundle: .module)`.
- No boolean parameters that change behaviour (`load(force: true)`): two intents or an enum.

## Control flow

- `guard` for preconditions, followed by one blank line. Consecutive entry `guard`s and their
  `defer` form one block.
- `defer` sits after the entry `guard`s and the declarations its cleanup needs, never in the middle
  of the main logic.
- A `switch` case whose body is a single value goes on the same line as its label. A case that
  does not fit in 100 columns stays wrapped as the formatter leaves it; a case with several
  statements, or a value spanning several lines, stays as it is.

  ```swift
  var image: FinanceImage {
      switch self {
      case .watchlist: .watchlist
      case .portfolio: .portfolio
      case .orders: .orders
      }
  }
  ```

- **Branch with `switch`**: over an enum, a tuple of the deciding values, an optional or a `Bool`.
  `if` only for one condition without `else`. Never `if / else`, an `else if` chain or a series of
  early `return`s.
- A `switch` that produces a value is an expression (`let title = switch state { … }`); a
  single-expression property or function omits `return`.
- Unwrap with the shorthand: `guard let self`, `if let quote`.
- Mutually exclusive states are an `enum`, never a set of optionals and booleans.
- Name compound conditions before using them (`let matchesSymbol = …`).
- Ternaries only to pick between two simple values (`isFavorite ? .remove : .add`); never nested,
  never for side effects.
- No force unwraps or `try!` outside tests and previews, except a `URL` from a string literal
  (`var baseURL: URL { .init(string: "https://api.sunfinance.example")! }`).

## Errors

- Throwing APIs use typed throws: `func quotes(for:) async throws(MarketDataError)`.
- How transport errors become domain errors is in [networking.md](networking.md#errors). A feature
  maps the domain error to its own issue enum (`WatchlistIssue`) with an exhaustive `switch`.
- `try?` only when the caller does not care why something failed; otherwise `do / catch`.

## No magic values

A literal that carries meaning gets a name, once, in the place that owns it.

| Literal | Lives in |
|---|---|
| User-facing text | String Catalog, keyed where it is used (`Text("watchlist.title", bundle: .module)`) |
| Spacing, radii, sizes | DesignSystem dimension tokens (`dimensions.spaceMedium`) |
| Colors, fonts, SF Symbols | `FinanceColor`, `FinanceFont`, `FinanceImage` or a feature's `ImageStyling` enum |
| Analytics names and keys | The event's `name` switch and `AnalyticsParameter` cases |
| API paths and query names | The domain's endpoint catalogue and `…PathSegment` / `…QueryKey` |
| JSON keys | `CodingKeys` |
| Durations, limits, retry counts | A configuration value or a property of the type that uses it |
| Accessibility identifiers | The feature's `AccessibilityIdentifying` enum |

`0`, `1`, `""` and `[]` as neutral starting values are not magic. Dummy data may be literal
([Dummy data](#dummy-data)).

A constant belongs to the type that uses it: a closed set of names is an `enum` with raw values; a
value one type uses is a computed property in its `private extension`
(`var pressedOpacity: Double { 0.7 }`); an identifier a type needs before `self` exists is a case
of a small `private enum` inside it (`SliceID.cash.rawValue`); a value that differs
per environment is configuration passed through `init`. Never a `Constants` type.

## No `static`

Write no `static` (or `class`) member, except:

1. a member a protocol requires (`==`, `<`);
2. an extension that gives a protocol-typed SwiftUI or Foundation parameter its leading dot:
   `extension ButtonStyle where Self == FinanceButtonStyle { static func finance(_:) }`,
   `extension FormatStyle where Self == SignedPercentFormatStyle { static var signedPercent }`, and
   each package's `LocalizedStringResource.BundleDescription.module` behind `bundle: .module`;
3. `VendorAnalytics.shared`, which imitates code we do not own;
4. a `static var dummy…` or `static func dummy…(…)` in a [dummy extension](#dummy-data)
   (`StockQuote.dummyApple`, `OrderDraft.dummy(.sell, .shares(16))`).

Localization keys are never `static`: the key is written where it is used,
`Text("watchlist.title", bundle: .module)`. Everything else has a non-static home:

- A preset is an enum case (`MockServerBehavior.realistic`, `CurrencyCode.eur`) or an initializer
  with real default values (`ServerEnvironment(mockBehavior:storageDirectory:)`).
- A helper is an instance member or an initializer (`MockLedger(seededAt:exchange:)`,
  `MarketEndpoint(matching:)` in a `private extension`), never a file-scope function.
- One-time setup is an instance method of a small type (`FontRegistrar().registerBundledFonts()`).
- Preview dependencies are instances (`PreviewObjectPool().watchlistDependencies()`); preview
  data, test fixtures and playground stand-in data are [dummy data](#dummy-data).

## Dummy data

Fake data is never a default value in production code: no default argument, stored property
default or preset holds a demo watchlist, an example key or a sample amount. A type that carries
such values is a plain value without defaults (`AppConfiguration` uses its memberwise
initializer), and its caller passes every value in.

Dummy data lives in one place per module, as `static var dummy…`, or `static func dummy…(…)`
when it needs parameters, in an extension of the model it belongs to, one file per extended type
named `<Type>Dummy.swift`:

| Module part | Folder |
|---|---|
| The App's demo setup | `SunFinance/Dummy/` |
| Package previews | `Sources/<Package>/Preview Content/Dummy/`, inside `#if DEBUG` |
| Tests | `Tests/Fakes/` (`SunFinanceTests/Fakes/` for the App) |
| Playground stand-ins | `Playground/Sources/Dummy/` |

```swift
extension AppConfiguration {
    static var dummy: AppConfiguration {
        .init(
            serverBehavior: .realistic,
            defaultWatchlist: TickerSymbol.dummyWatchlist,
            vendorAnalyticsAPIKey: "demo-vendor-key",
            defaultsSuiteName: nil,
            mockServerStorageURL: URL.applicationSupportDirectory.appending(path: "MockServer")
        )
    }
}
```

- Every member is named `dummy…`: `dummy` for the only value of a type, `dummy<Name>` for one of
  several (`StockQuote.dummyGaining`, `Date.dummyNow`), `dummy<Role>` for a list
  (`TickerSymbol.dummyWatchlist: [TickerSymbol]`). A private generator inside the extension is a
  `private static func dummy…` too.
- A use writes `Type.dummyX`, or `.dummyX` where the context type is exactly that type
  (`AppDependencies(configuration: .dummy)`, `QuoteRowView(quote: .dummyGaining, …)`).
- A dummy is `nonisolated` when it is used off the main actor (`@Test(arguments:)`, a nonisolated
  preview service).
- Previews, tests and playgrounds each own their dummies. A test target's dummy may share a name
  with a preview dummy of its package; the test's own declaration wins.
- The mock backend's seeded content (MockLedger's seed trades, the MockExchange and companies
  fixtures) is the backend's data, not dummy data, and stays where it is.

## Comments

- No explanatory comments: no `//` notes, no `///` documentation, no trailing comments. Rename or
  extract until the code explains itself.
- The only comments are the file header, `// swift-tools-version`, the
  [section marks](#section-marks), and `// Given` / `// When` / `// Then` in tests.
- No commented-out code, `TODO`s or banners.

## Extensions and collections

- Extend a standard type only to name an intention used in more than one place
  (`String.isBlank`, `Set.toggle(_:)`).
- Never extend a concrete collection (`extension [StockQuote]`). A collection with rules of its
  own is a domain type.
- Rules about one element belong to the element (`StockQuote.isGain`).

## Concurrency

- Swift 6 strict concurrency. No `@unchecked Sendable`, no `nonisolated(unsafe)`.
- Async work, cancellation and streams follow [view-model.md](view-model.md#async-loading) and
  [networking.md](networking.md#providers); isolation follows
  [architecture.md](architecture.md#isolation).
- Everything that exists only for previews or debugging is inside `#if DEBUG`.
