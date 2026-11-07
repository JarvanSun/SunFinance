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
- When the type is known from context, write `.init(...)`.

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
- `some Protocol` for parameters, `any Protocol` for stored existentials.
- No boolean parameters that change behaviour (`load(force: true)`): two intents or an enum.

## Control flow

- `guard` for preconditions, followed by one blank line. Consecutive entry `guard`s and their
  `defer` form one block.
- `defer` sits after the entry `guard`s and the declarations its cleanup needs, never in the middle
  of the main logic.
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
- No force unwraps or `try!` outside tests and previews, except a file-scope `private let` `URL`
  from a string literal.

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

`0`, `1`, `""` and `[]` as neutral starting values are not magic. Sample data in previews,
`Preview Content/` and test fixtures may be literal.

A constant belongs to the type that uses it: a closed set of names is an `enum` with raw values; a
value one type uses is a computed property in its `private extension`
(`var pressedOpacity: Double { 0.7 }`); a value an initializer needs before `self` exists is a
file-scope `private let` below the type (`private let cashSliceID = "cash"`); a value that differs
per environment is configuration passed through `init`. Never a `Constants` type.

## No `static`

Write no `static` (or `class`) member, except:

1. a member a protocol requires (`==`, `<`);
2. an extension that gives a protocol-typed SwiftUI or Foundation parameter its leading dot:
   `extension ButtonStyle where Self == FinanceButtonStyle { static func finance(_:) }`,
   `extension FormatStyle where Self == SignedPercentFormatStyle { static var signedPercent }`, and
   each package's `LocalizedStringResource.BundleDescription.module` behind `bundle: .module`;
3. `VendorAnalytics.shared`, which imitates code we do not own.

Localization keys are never `static`: the key is written where it is used,
`Text("watchlist.title", bundle: .module)`. Everything else has a non-static home:

- A preset is an enum case (`MockServerBehavior.realistic`, `CurrencyCode.eur`) or an initializer
  with default values (`AppConfiguration()`, `ServerEnvironment(mockBehavior:storageDirectory:)`).
- A helper is an instance member, an initializer (`MockLedger(seededAt:exchange:)`) or a
  file-scope `private func` (`marketEndpoint(matching:)`).
- One-time setup is a lazily initialized file-scope `private let` (`FontRegistrar`).
- Preview data and test fixtures are instances (`PreviewObjectPool().quotes`), initializers with
  fixture defaults (`OrderDraft(.sell, .shares(16))`) or `nonisolated let` constants in `Fakes/`;
  `@Test(arguments:)` takes array literals of them.

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
