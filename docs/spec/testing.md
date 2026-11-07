# Testing and Previews

## Swift Testing

- Every test uses Swift Testing (`import Testing`, `@Test`, `#expect`, `#require`). No XCTest.
- One test file per source file with logic, mirroring its path below the target folder:
  `Sources/Watchlist/Screens/Watchlist/Model/WatchlistIssue.swift` →
  `Tests/Screens/Watchlist/Model/WatchlistIssueTests.swift`. Pure declarations (a protocol, an
  enum without members) have none.
- A test file holds one `struct <Type>Tests` and never covers two source files.
- The App's code is tested in `SunFinanceTests`, mirroring the App's folders.

## Test shape

```swift
@Test(arguments: [false, true])
func toggleFavoriteThenFlipsSavesAndTracks(wasFavorite: Bool) {
    // Given
    let favoriteStore = FavoriteSymbolStoreSpy(favoriteSymbols: wasFavorite ? ["AAPL"] : [])
    let tracker = AnalyticsTrackerSpy()
    let viewModel = makeViewModel(favoriteStore: favoriteStore, tracker: tracker)

    // When
    viewModel.toggleFavorite("AAPL")

    // Then
    let expectedEvent = WatchlistEvent.favoriteToggled(symbol: "AAPL", isFavorite: !wasFavorite)
    #expect(viewModel.isFavorite("AAPL") == !wasFavorite)
    #expect(favoriteStore.savedFavoriteSymbols == [viewModel.favoriteSymbols])
    #expect(tracker.events(of: WatchlistEvent.self) == [expectedEvent])
}
```

- Name: `<method>When<condition>Then<result>`; drop `When…` when there is no condition.
- Section comments are the only comments in tests, and each test uses one of these shapes:
  - `// Given`, `// When`, `// Then` (the sample above).
  - `// Given`, `// Then` when the arrangement is the call under test, or `// Given` and
    `// When / Then` when the call is the expectation itself.
  - `// Given / When`, `// Then` when the step that builds the subject is the step under test:

    ```swift
    @Test func placeholderBeforeFirstLoadThenIsNil() {
        // Given / When
        let viewModel = makeViewModel()

        // Then
        #expect(viewModel.placeholder == nil)
    }
    ```

  - No comment at all when the body is only the expectation:

    ```swift
    func valueThenExistsOnlyOnceLoaded(state: LoadState<Int, String>, expected: Int?) {
        #expect(state.value == expected)
    }
    ```

  A lone `// Then` is never written, and `// When` never appears without `// Given` before it.
- One behaviour per test; several `#expect`s may describe one outcome. Variations use
  `@Test(arguments:)`, not copied tests.
- The system under test is built by a `make…` function in a `private extension <Type>Tests` at
  the end of the file, with defaults for every collaborator.
- Tests never sleep: they await the method under test, and time is an injected
  `any Clock<Duration>`.

## Fakes

Fakes live in `Tests/Fakes/`, one per file, named by role. No mocking frameworks.

| Suffix | Does |
|---|---|
| `Stub` | Returns canned values (`QuoteProviderStub`) |
| `Spy` | Records calls in `private(set)` arrays (`AnalyticsTrackerSpy`) |
| `Fake` | A working lightweight implementation |

Fixtures are [dummy extensions](swift-style.md#dummy-data) in `Fakes/<Type>Dummy.swift`, one
file per extended type: a named value is a `nonisolated static var dummy…`
(`StockQuote.dummyApple`, `Account.dummy`, `Date.dummyNow`), a family of values a
`nonisolated static func dummy…(…)` with fixture defaults (`OrderDraft.dummy(.sell, .shares(16))`,
`Position.dummy(holding: "AAPL", quantity: 3)`). Tests never use a preview dummy. A symbol is its
literal (`"AAPL"`). `@Test(arguments:)` takes array literals of these. Other test helpers
(`LocalizationCatalog`) also live in `Fakes/`.

## What must be tested

| Type | Tests |
|---|---|
| ViewModel | Every intent, placeholder case and tracked event, cancellation, overlapping loads |
| Model, presentation extension | Every rule and `switch` branch |
| Mapping (DTO → model, errors) | Every field and every failure |
| Request type | Path, method, query items, body |
| Analytics pipeline | Consent, validation, enrichment, vendor mapping |
| Extensions, `FormatStyle`s | Every method, with edge cases (empty, zero, negative, a second locale) |
| DesignSystem tokens and styles | Every token's default and override, every `FinanceMotion` timing, every style kind |
| `LoadState`, `RangedHistory` | Every rule, including answers for a range no longer selected |
| Chart logic | Downsampling, resampling, candle merging, the value scale, every descriptor |

Views are not unit-tested; previews verify them.

## Previews

One `#Preview` at the end of each view file and each DesignSystem style or token file, inside
`#if DEBUG`. Never a separate preview file, never one `#Preview` per state.

| View | How its states are shown |
|---|---|
| Screen | One `#Preview(_:arguments:)` over `<Feature>PreviewState` |
| View driven by one enum (a placeholder) | One `#Preview(_:arguments:)` over its cases |
| Row, section, DesignSystem component | One `#Preview` stacking every data variant |
| DesignSystem style or token | Every case; a button style shows every kind enabled and disabled |
| Motion piece | An interactive trigger that replays every effect in the file |
| Small view with nothing to vary | One plain `#Preview`, or none if it only makes sense in its parent |

```swift
#if DEBUG
@available(iOS 26, *)
#Preview("Watchlist", arguments: WatchlistPreviewState.allCases) { state in
    NavigationStack {
        WatchlistView(viewModel: PreviewObjectPool().watchlistViewModel(state))
    }
    .environment(\.locale, state.locale)
}
#endif
```

- `#Preview(_:arguments:)` needs `@available(iOS 26, *)`; the deployment target stays iOS 18.
- `<Feature>PreviewState` lives in `Preview Content/`. Its cases are data states the canvas
  cannot produce (content, loading, empty, each failure) plus `german`, applied through
  `state.locale`, because the canvas has no language switch. A new state is a new case.
- Color scheme, Dynamic Type and orientation are checked with the canvas Variants; previews never
  set `.preferredColorScheme` or `.dynamicTypeSize`.
- A screen that sets `navigationTitle`, `searchable` or `toolbar` is wrapped in a
  `NavigationStack`; nothing else is. Preview the `*HostView` to see navigation.
- Data comes from the package's [dummy extensions](swift-style.md#dummy-data) in
  `Preview Content/Dummy/` (`QuoteRowView(quote: .dummyGaining, favoriteAction: .add)`).
- Dependencies and view models come from the package's `PreviewObjectPool` (`#if DEBUG`), a struct
  whose instance members (`PreviewObjectPool().watchlistDependencies()`) return new, isolated
  objects on every call and provides no views, except the stand-in screen behind
  each `FeatureEntry`.
