# Analytics

The app is built as if it shipped with a third-party analytics SDK: the event model, pipeline,
consent, privacy rules and vendor adapter are real; the vendor SDK is a fake with a vendor-style
API that only records calls in memory.

## Layers

```text
Feature ViewModel        tracker.track(WatchlistEvent.favoriteToggled(symbol:isFavorite:))
   ▼
AnalyticsTracking        public protocol, the only thing features know
   ▼
AnalyticsTracker         consent → validation → enrichment → every destination
   ▼
AnalyticsDestination     send(_:), applyConsent(_:); one per vendor or sink
   ├── VendorAnalyticsDestination   our event → vendor call
   │       ▼
   │   VendorAnalyticsSDK           fake vendor module (separate target)
   └── ConsoleAnalyticsDestination  DEBUG only: prints every event
```

Everything lives in `Core/FinanceCore/Sources/FinanceCore/Analytics/`. `VendorAnalyticsSDK` is a
separate target of the same package, imported only by `VendorAnalyticsDestination`. Isolation is
in [architecture.md](architecture.md#isolation).

## Event model

An event is a value conforming to `AnalyticsEvent`: a `name: AnalyticsEventName` and
`parameters: [AnalyticsParameter: AnalyticsValue]`.

- `AnalyticsParameter` is an `enum` in FinanceCore with `String` raw values, one case per key
  (`case resultCount = "result_count"`). `AnalyticsEventName` is a string wrapper; each event writes
  its names once, in its `name` switch:

  ```swift
  var name: AnalyticsEventName {
      switch self {
      case .screenViewed:
          .init("watchlist_viewed")
      case .quotesLoaded:
          .init("watchlist_quotes_loaded")
      …
      }
  }
  ```
- `AnalyticsValue` is an enum (`text`, `integer`, `decimal`, `boolean`).
- Each flow has one `<Flow>Event` enum conforming to `AnalyticsEvent` and `Equatable`
  (`WatchlistEvent`; Instrument has `QuoteDetailEvent` and `TradingEvent`). A new tracked action
  is a new case.
- Names are `snake_case`, `<feature>_<object>_<action>`, past tense. A parameter value is a
  `snake_case` string from the feature's enum, never a localized title.

## What we track

Only actions that answer a product question. A feature's events are added here before they are
implemented.

| Event | When | Parameters | Question it answers |
|---|---|---|---|
| `watchlist_viewed` | Watchlist appears | — | How often is the main screen used? |
| `watchlist_quotes_loaded` | Quotes load | `result_count` | Do users have a meaningful watchlist? |
| `watchlist_quotes_failed` | Quotes fail | `failure_reason` | How often do users see errors, and which? |
| `watchlist_search_submitted` | Search submitted | `result_count` (rows plus results) | Does search find what people look for? |
| `watchlist_sort_changed` | Sort order changes | `sort_order` | Which order do people prefer? |
| `watchlist_favorite_toggled` | Star toggled | `symbol`, `is_favorite` | Which symbols do people care about? |
| `watchlist_quote_opened` | Row tapped | `symbol` | Which quotes lead to detail views? |
| `watchlist_symbol_added` | A search result is added | `symbol` | Does symbol search grow watchlists? |
| `quote_detail_viewed` | Detail appears | `symbol` | Which stocks get looked at? |
| `quote_detail_range_changed` | Chart range changes | `symbol`, `range` | Which time ranges matter? |
| `quote_detail_chart_style_changed` | Line / candles toggled | `chart_style` | Are candlesticks worth keeping? |
| `quote_detail_chart_scrubbed` | A scrub ends | `symbol`, `range` | Do people read the chart in detail? |
| `trading_ticket_opened` | Ticket appears, once per ticket | `symbol`, `side`, `source` (`quote_detail`, `position`) | Where do trades start? |
| `trading_order_reviewed` | Preview loads | `side`, `order_type`, `trigger` | Which order types get considered? |
| `trading_order_placed` | Server answers the placement, rejections included | `symbol`, `side`, `order_type`, `trigger`, `status` | Which order types get used, and do they fill at once? |
| `trading_order_failed` | Preview or placing fails | `failure_reason` | Why do orders fail? |
| `trading_order_cancelled` | User cancels an open order (tracked by Orders) | `order_type`, `trigger` | Which scheduled orders get abandoned? |
| `orders_viewed` | Orders appears, once its open orders are known | `open_count` | Do people keep orders open? |
| `portfolio_viewed` | Portfolio appears, once its positions are known | `position_count` | How diversified are accounts? |
| `portfolio_range_changed` | Value chart range changes | `range` | Which horizon do people judge by? |
| `portfolio_position_opened` | Position tapped | `symbol` | Which holdings get checked? |

`order_type` (`market`, `limit`, `stop`, `stop_limit`) and `trigger` (`now`, `price`, `time`) are
the raw values of `OrderDraft.kind` and `OrderDraft.triggerKind`, so the ticket and Orders describe
an order the same way.

## Privacy

- **Consent first.** Until consent is granted, `AnalyticsTracker` drops events (it does not queue
  them). Consent is stored by `UserDefaultsAnalyticsConsent` and defaults to not granted. The app
  has no settings, so in the App the pipeline stops at the consent check; the FinanceCore and
  Watchlist playgrounds grant it to show what the vendor would receive.
- **No personal data.** Never track free text (search queries), amounts, prices the user typed,
  quantities, names, emails, device identifiers or location; order events describe the kind of
  order, never its size. Symbols are public market data and may be tracked.
- The tracker drops any event that uses a parameter whose `isPersonalData` is true (`query`,
  `email`, `name`, `amount`, `price`, `quantity`, `device_id`); `AnalyticsParameterTests` covers
  every case. A test per
  feature proves its search event carries no query text.

## The pipeline

`AnalyticsTracker` is a `public final class` conforming to `AnalyticsTracking`.
`applyConsent()` pushes the current consent to every destination; the composition root calls it
at launch. `track(_:)` calls one private step each, in order:

1. check consent,
2. validate the event,
3. add common context (`app_version`, `locale`),
4. forward it to every destination.

`VendorAnalyticsDestination` is the only code that knows the vendor: it configures the SDK with the
API key from the composition root, converts names and parameters to the vendor's
`VendorAnalytics.shared.logEvent(_:parameters:)`, and maps consent to the vendor's opt-out.

## Testing

- ViewModel tests use `AnalyticsTrackerSpy` and assert the exact events with `events(of:)`.
- `AnalyticsTrackerTests` cover consent, validation and enrichment;
  `VendorAnalyticsDestinationTests` the names and parameters the vendor receives.
