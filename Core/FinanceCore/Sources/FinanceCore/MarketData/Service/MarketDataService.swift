//
//  MarketDataService.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore

public struct MarketDataService:
    QuoteProviding, QuoteDetailProviding, PriceHistoryProviding, SymbolSearching
{
    private let client: BackendClient

    public init(environment: ServerEnvironment) {
        self.init(client: BackendClient(environment: environment))
    }

    init(client: BackendClient) {
        self.client = client
    }

    public func quotes(for symbols: [TickerSymbol]) async throws(MarketDataError) -> [StockQuote] {
        let response = try await send(QuotesRequest(symbols: symbols))
        return try response.quotes.map(StockQuote.init(_:))
    }

    public func quoteDetail(for symbol: TickerSymbol) async throws(MarketDataError) -> QuoteDetail {
        try QuoteDetail(try await send(QuoteDetailRequest(symbol: symbol)))
    }

    public func priceHistory(
        for symbol: TickerSymbol,
        range: HistoryRange
    ) async throws(MarketDataError) -> PriceHistory {
        try PriceHistory(try await send(PriceHistoryRequest(symbol: symbol, range: range)))
    }

    public func symbols(matching query: String) async throws(MarketDataError) -> [SymbolMatch] {
        let response = try await send(SymbolSearchRequest(query: query))
        return try response.matches.map(SymbolMatch.init(_:))
    }
}

private extension MarketDataService {
    func send<Request: APIRequest>(
        _ request: Request
    ) async throws(MarketDataError) -> Request.Response {
        do {
            return try await client.send(request)
        } catch {
            throw MarketDataError(error)
        }
    }
}
