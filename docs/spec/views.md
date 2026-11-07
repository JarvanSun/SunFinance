# Views

A view lays out values it is given and forwards what the user does. A screen's `body` shows at a
glance how many sections it has and where its presentations come from.

## The body is the table of contents

`Features/Instrument/Sources/Instrument/Screens/QuoteDetail/QuoteDetailView.swift`:

```swift
struct QuoteDetailView: View {
    @Environment(\.dimensions) private var dimensions

    let viewModel: QuoteDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: dimensions.spaceXXLarge) {
                PriceChartSection(
                    history: viewModel.history.shown,
                    trading: viewModel.tradingSnapshot,
                    companyName: viewModel.companyName,
                    style: viewModel.chartStyle,
                    range: viewModel.range,
                    canShowCandles: viewModel.canShowCandles,
                    onScrub: viewModel.scrub(to:),
                    onSelectRange: viewModel.selectRange,
                    onSelectStyle: viewModel.selectChartStyle
                )

                KeyStatisticsView(rows: viewModel.statisticRows)
            }
            .safeAreaInset(edge: .top, if: viewModel.header) { header in
                QuoteHeaderView(header: header)
                    .padding(.bottom, dimensions.spaceXXLarge)
            }
            .safeAreaInset(edge: .bottom, if: viewModel.position) { position in
                PositionSectionView(position: position)
                    .padding(.top, dimensions.spaceXXLarge)
            }
            .padding(dimensions.spaceLargeSmall)
        }
        .background(FinanceColor.background.color)
        .floatingBottomBar {
            TradeActionsView(actions: viewModel.tradeActions, onTrade: viewModel.openTicket)
        }
        .overlay(if: viewModel.placeholder) { placeholder in
            QuoteDetailPlaceholderView(placeholder: placeholder, onRetry: viewModel.retry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(FinanceColor.background.color)
        }
        .navigationTitle(Text(verbatim: viewModel.title))
        .navigationBarTitleDisplayMode(.inline)
        .refreshable { await viewModel.refresh() }
        .task(id: viewModel.reloadRequest) { await viewModel.reload() }
        .task(id: viewModel.historyRequest) { await viewModel.loadHistory() }
        .onAppear(perform: viewModel.trackScreenView)
    }
}
```

- Each top-level section is a named view in the screen's `Views/`, separated by one blank line,
  named for what it shows (`PriceChartSection`), never where it sits (`TopView`).
- A section receives the values and actions it needs, not the ViewModel, unless it needs bindings.
- Small stateless fragments may stay as `private` computed views in the section's file. Extract a
  type when a fragment has its own state or task, a meaningful branch, its own preview, or hides
  the parent's modifier order.

## State in the body

- Optional content is attached with DesignSystem's `overlay(if:)` or `safeAreaInset(edge:if:)`,
  never `if let` in a `body`. An optional section at the top or bottom of a stack is a
  `safeAreaInset(edge:if:)` on that stack.
- A placeholder that replaces the screen is attached after the bottom bar, so it covers the
  screen's actions too.
- Mutually exclusive content is a `switch` over an enum from the ViewModel.
- No conditional expressions that pick strings, symbols, colors or actions: write
  `Image(style: addition.image)`, never `Image(systemName: isAdded ? … : …)`.
- No literal numbers, strings or symbol names ([swift-style.md](swift-style.md#no-magic-values)).

## Lists

- The `body` passes `viewModel.content` once to a private `list(_:)`, so filtering and sorting run
  once per update.
- `List` → `ForEach` → row view is visible in the file; `ForEach` is never hidden in a wrapper.
- Sections come from the ViewModel and are switched over; an empty section is left out.
- A row view is the row: it adds no `Section` or chevron of its own. Rows are buttons with
  `.buttonStyle(.finance(.row))`.
- Loading, empty and failure use `overlay(if:)`, never fake rows.
- Search is `.searchable`; sorting and filters are a toolbar `Menu`.

## Async work and lifecycle

- Loads run from `.task(id:)` on a request value the ViewModel holds, so SwiftUI starts, replaces
  and cancels them; a button that reloads calls an intent that replaces the value
  ([view-model.md](view-model.md#async-loading)). Views hold neither a `Task` nor a request value.
- The screen root tracks its view with `.onAppear(perform: viewModel.trackScreenView)`.

## Accessibility

The rules are in [design-system.md](design-system.md#accessibility). In a view:

- Every interactive element has an identifier from the feature's `AccessibilityIdentifying` enum:
  `.accessibilityIdentifier(WatchlistAccessibility.list)`.
- A row that reads as one thing is one element (`.accessibilityElement(children:)`) with its label
  from the model's presentation (`quote.accessibilityLabel`).
- Nothing visible is hidden from VoiceOver.

Previews are in [testing.md](testing.md#previews).
