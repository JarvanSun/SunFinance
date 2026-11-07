# Networking

All network access lives in `Core/FinanceCore`. Features see domain models and one error per
domain; they never see URLs, HTTP or JSON.

| Folder of `Sources/FinanceCore/` | Owns |
|---|---|
| `Networking/` | Server environments, the client, the HTTP names every request shares |
| `MockServer/` | The mock server, the mock exchange, each domain's routes and engine |
| `MarketData/` | Public market data: quotes, price history, symbol search |
| `Brokerage/` | The demo account: balance, positions, portfolio history, orders |

`MarketData/` and `Brokerage/` each use `Networking/` and never each other's types.

## Public and internal

| Public | Internal to FinanceCore |
|---|---|
| Values, domain models and errors, provider protocols, `MarketDataService` and `BrokerageService` (`init(environment:)`), the watchlist and favorites stores, the analytics types | Endpoint catalogues, request types, DTOs, `…PathSegment` and `…QueryKey` names |
| `ServerEnvironment` and `init(mockBehavior:storageDirectory:)`, `MockServerBehavior` and its cases | `BackendClient`, `BackendFailure`, `ServerTransport`, `HeaderKey`, `HTTPStatus`, `APIVersion`, the JSON coders |
| `MockExchange()`, `quote(for:at:)`, `eurRate(of:at:)`, `ExchangeQuote` (for the FinanceCore playground) | The mock server, its routes, the mock brokerage engine, the exchange's internals |

Tests reach internal parts with `@testable import FinanceCore`.

## Layers

```text
Feature ViewModel      calls placer.place(_:idempotencyKey:), catches BrokerageError
Provider protocol      QuoteProviding, OrderPlacing, AccountProviding…
<Domain>Service        implements the providers: sends requests, maps DTO → model and errors
Endpoint catalogue     <Domain>Endpoint, one request type and its DTOs per endpoint
BackendClient          Networking/
SunKit SunCore         APIClient → RequestBuilder → RequestSending
Transport              MockServer (the app) or URLSession
```

Each layer talks only to the one below. A ViewModel never builds a request; a request type never
maps to a domain model.

## Package layout

Each domain folder has the same shape:

```text
Brokerage/
├── Endpoints/
│   ├── BrokerageEndpoint.swift    # the complete list of this domain's endpoints
│   ├── PlaceOrder/                # one folder per endpoint: PlaceOrderRequest, OrderDTO, FillDTO
│   └── Shared/                    # DTOs several endpoints use: MoneyDTO, OrderDraftDTO
├── HTTP/                          # BrokeragePathSegment, BrokerageQueryKey
├── Models/                        # domain models and their validation
├── Providers/                     # public provider protocols
└── Service/                       # BrokerageService
```

Names a domain shares between requests and mock routes carry its prefix (`MarketPathSegment`),
because the package is one name space.

## The endpoint catalogue

`<Domain>Endpoint` is an enum of every endpoint the domain may call, with `path` and `method`,
and an `init?(path:method:)` the mock routes match with. A request not in it does not exist.

| Domain | Endpoint | Method and path |
|---|---|---|
| MarketData | `quotes` | `GET v1/quotes?symbols=` |
| MarketData | `quoteDetail(TickerSymbol)` | `GET v1/symbols/{symbol}` (quote, open, day and 52-week range, volume) |
| MarketData | `priceHistory(TickerSymbol)` | `GET v1/symbols/{symbol}/history?range=` (candles; the interval follows the range) |
| MarketData | `symbolSearch` | `GET v1/search?query=` (exact symbol, symbol prefix, then company name; at most 10) |
| Brokerage | `account` | `GET v1/account` |
| Brokerage | `positions` | `GET v1/portfolio/positions` |
| Brokerage | `portfolioHistory` | `GET v1/portfolio/history?range=` |
| Brokerage | `orders` | `GET v1/orders?status=&symbol=&cursor=` (`open` or `past`; `symbol` optional) |
| Brokerage | `previewOrder` | `POST v1/orders/preview` |
| Brokerage | `placeOrder` | `POST v1/orders` (a rejected order comes back with status `rejected`) |
| Brokerage | `cancelOrder(Order.ID)` | `DELETE v1/orders/{id}` |

Each endpoint has one request type conforming to SunKit's `APIRequest`, in its endpoint folder:

```swift
struct QuotesRequest: APIRequest {
    typealias Response = QuotesResponseDTO

    let symbols: [TickerSymbol]

    var path: [String] { MarketEndpoint.quotes.path }

    var method: HTTPMethod { MarketEndpoint.quotes.method }

    var queryItems: [URLQueryItem] {
        [.init(name: MarketQueryKey.symbols.rawValue, value: joinedSymbols)]
    }
}

private extension QuotesRequest {
    var joinedSymbols: String {
        symbols.map(\.rawValue).joined(separator: ListSeparator.comma.rawValue)
    }
}
```

- Path and method come from the catalogue, query names from `…QueryKey`. No string literals.
- A write declares its body explicitly and is never retried automatically.
- Lists that grow without bound (orders) are paged with an opaque `cursor`; the provider returns
  a `Page<Element>`. A screen that needs a whole list narrows it on the server (`symbol:`) and
  follows every page with `allOrders(_:for:)`; it never filters one page on the device.

## DTOs and mapping

- A DTO mirrors the JSON exactly: `Codable` (the mock routes use the same types), `Sendable`,
  `CodingKeys` for every renamed key. A field is optional only where the server may omit it.
- Names: a response body is `<Endpoint>ResponseDTO`, a request body `<Endpoint>RequestDTO`, an
  object inside either `<Object>DTO` (`QuoteDTO`).
- Mapping lives in the domain model: `StockQuote(_ dto: QuoteDTO) throws(MarketDataError)`. An
  invalid DTO throws `.decoding`; it is never silently defaulted.
- Money is `Money` (`Decimal` amount plus a `CurrencyCode`), never `Double`. `CurrencyCode` is an
  enum of the ISO 4217 codes the app supports (`EUR`, `USD`, `JPY`); a DTO with any other code is
  invalid. Quantities are `Decimal`. Timestamps are `Date`, ISO 8601 in both directions
  (`makeBackendEncoder()`, `makeBackendDecoder()`).

## Errors

`BackendClient` maps every failure once into `BackendFailure` (`init(_ error: Error)`); each
domain error converts it with `init(_ failure: BackendFailure)`, used only by that domain's
service. `MarketDataError` and `BrokerageError` have the same cases:

| Case | From |
|---|---|
| `offline` | `URLError` for no connection, lost connection, timeout |
| `server(statusCode:)` | SunKit `HTTPError` |
| `decoding` | Anything else: `DecodingError`, an invalid DTO, an unexpected body |
| `cancelled` | `CancellationError` |

A case is added only when a screen must react to it differently; a rejected order is a status,
not an error.

## Server environments

`ServerEnvironment` (`Networking/Environment/`) is a value holding a base URL and a transport;
only the type and its mock initializer are public. `init(mockBehavior:storageDirectory:)`
assembles the whole mock backend: one `MockExchange`, the mock brokerage (persisted as `brokerage.json` in the
directory, in memory for `nil`) and every domain's routes. Only the services read the
environment. A real backend would be a new `ServerEnvironment`, nothing else.

Headers and timeouts are SunKit defaults (`Accept: application/json`, `Content-Type` for a JSON
body, the timeout) and are never repeated. The only header the app adds is
`Idempotency-Key` on placing an order (`HeaderKey`); status codes the mock answers with are
`HTTPStatus` cases.

## Mock server

- `MockServer` is a SunKit `RequestSender`. It receives real `URLRequest`s, asks each `MockRoute`
  whether it handles one, and returns real `HTTPURLResponse`s with JSON bodies. Unknown paths
  return `404`; a missing or unknown query value or a malformed body returns `400`; bad input
  never crashes it.
- Each domain has its routes in `MockServer/<Domain>/` (`MarketDataMockRoutes`,
  `BrokerageMockRoutes`). Fixtures live in `Resources/<Reader>/` (`MockExchange/listings.json`,
  `MockServer/companies.json`); `.process` flattens them, so names are unique across the package.
  They are decoded with `Bundle.fixture(named:as:)`. There is no authentication.
- **Mock exchange.** `MockExchange` is the single source of prices. A price is a deterministic
  function of symbol and time (seeded waves around the fixture's reference price), so chart,
  quote and fill agree. It knows each venue's trading hours and time zone and the EUR/USD rate.
- **Mock brokerage.** `MockBrokerage` keeps the demo account (cash, fills, orders, cash entries)
  behind a lock, persisted as JSON in Application Support. On every request it first settles
  everything up to now: triggered open orders fill at that moment's price, scheduled orders whose
  time came are released, and orders placed outside trading hours wait for the open.
- `MockServerBehavior` is an enum whose cases set latency and read and write failure rates (a
  failure answers `503`): `.realistic` (the app: 250–900 ms, 5 % of reads fail, writes never),
  `.instant` (tests), `.failingReads` (reads fail, writes succeed) and `.alwaysFailing`
  (error-path tests).

## Providers

```swift
public protocol QuoteProviding: Sendable {
    func quotes(for symbols: [TickerSymbol]) async throws(MarketDataError) -> [StockQuote]
}
```

- One `public`, `Sendable` protocol per capability, named `-ing` (`SymbolSearching`,
  `OrderPlacing`), in the domain's `Providers/`.
- Placing an order takes an `IdempotencyKey`, kept per draft by Review's `PlacementKeys` and
  reused on a retry ([product.md](product.md#review-and-submit)).
- A feature's dependencies list only the protocols it calls.
- Live updates are an `AsyncStream` from a provider method
  (`PositionProviding.portfolioUpdates(every:)`, 15 seconds by default). The provider owns the
  polling and the screen's `.task` its lifetime. The stream waits one interval before its first
  poll and yields each poll as a `Result`, so a failed poll reaches the ViewModel.
- Providers do not cache, retry or check cancellation.
