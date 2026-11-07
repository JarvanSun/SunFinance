//
//  MarketDataMockRoutes.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct MarketDataMockRoutes: MockRoute {
    private let exchange: MockExchange
    private let companies: [TickerSymbol: CompanyDTO]

    init(exchange: MockExchange) {
        let fixture = try? Bundle.module.fixture(
            named: FixtureFile.companies.rawValue,
            as: CompaniesDTO.self
        )
        self.exchange = exchange
        companies = Dictionary((fixture?.companies ?? []).map { ($0.symbol, $0) }) { first, _ in
            first
        }
    }

    func response(to request: MockRequest) throws -> MockResponse? {
        switch MarketEndpoint(path: request.path, method: request.method) {
        case .quotes: try .init(json: QuotesResponseDTO(quotes: quotes(for: request)))
        case .quoteDetail(let symbol):
            try detail(for: symbol, at: request.date).map { try .init(json: $0) }
                ?? .init(status: .notFound)
        case .priceHistory(let symbol): try historyResponse(for: symbol, request: request)
        case .symbolSearch: try searchResponse(for: request)
        case nil: nil
        }
    }
}

// MARK: - Private

private extension MarketDataMockRoutes {
    var searchLimit: Int { 10 }

    func quotes(for request: MockRequest) -> [QuoteDTO] {
        requestedSymbols(in: request).compactMap { quote(for: $0, at: request.date) }
    }

    func requestedSymbols(in request: MockRequest) -> [TickerSymbol] {
        let joinedSymbols = request.query(MarketQueryKey.symbols.rawValue) ?? ""
        return joinedSymbols.split(separator: ListSeparator.comma.rawValue).map {
            TickerSymbol(rawValue: String($0))
        }
    }

    func detail(for symbol: TickerSymbol, at date: Date) -> QuoteDetailResponseDTO? {
        let day = exchange.candles(for: symbol, range: .day, endingAt: date)
        let year = exchange.candles(for: symbol, range: .year, endingAt: date)
        guard let quote = quote(for: symbol, at: date), let open = day.first?.open else {
            return nil
        }

        return QuoteDetailResponseDTO(
            quote: quote,
            open: open,
            dayHigh: day.map(\.high).max() ?? open,
            dayLow: day.map(\.low).min() ?? open,
            yearHigh: year.map(\.high).max() ?? open,
            yearLow: year.map(\.low).min() ?? open,
            volume: day.reduce(0) { $0 + $1.volume }
        )
    }

    func historyResponse(for symbol: TickerSymbol, request: MockRequest) throws -> MockResponse {
        let range = request.query(MarketQueryKey.range.rawValue).flatMap(
            HistoryRange.init(rawValue:)
        )
        guard let range else { return .init(status: .badRequest) }
        guard let quote = exchange.quote(for: symbol, at: request.date) else {
            return .init(status: .notFound)
        }

        let candles = exchange.candles(for: symbol, range: range, endingAt: request.date)
        return try .init(
            json: PriceHistoryResponseDTO(
                symbol: symbol.rawValue,
                range: range.rawValue,
                currency: quote.price.currency.rawValue,
                previousClose: range == .day ? quote.previousClose.amount : nil,
                candles: candles.map(dto(of:))
            )
        )
    }

    func searchResponse(for request: MockRequest) throws -> MockResponse {
        guard let query = request.query(MarketQueryKey.query.rawValue) else {
            return .init(status: .badRequest)
        }

        let needle = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let ranked = companies.values.compactMap { company in
            SearchRank(of: company, for: needle).map { (company: company, rank: $0) }
        }
        let matches =
            ranked
            .sorted { first, second in
                first.rank == second.rank
                    ? first.company.marketCap > second.company.marketCap
                    : first.rank < second.rank
            }
            .prefix(searchLimit)
            .compactMap { match(for: $0.company, at: request.date) }
        return try .init(json: SymbolSearchResponseDTO(matches: matches))
    }

    func match(for company: CompanyDTO, at date: Date) -> SymbolMatchDTO? {
        guard
            let venue = exchange.venue(of: company.symbol),
            let price = exchange.price(of: company.symbol, at: date)
        else { return nil }

        return SymbolMatchDTO(
            symbol: company.symbol.rawValue,
            companyName: company.companyName,
            exchange: venue.rawValue.uppercased(),
            currency: price.currency.rawValue
        )
    }

    func dto(of candle: ExchangeCandle) -> CandleDTO {
        .init(
            start: candle.start,
            open: candle.open,
            high: candle.high,
            low: candle.low,
            close: candle.close,
            volume: candle.volume
        )
    }

    func quote(for symbol: TickerSymbol, at date: Date) -> QuoteDTO? {
        guard
            let company = companies[symbol],
            let exchangeQuote = exchange.quote(for: symbol, at: date)
        else { return nil }

        return QuoteDTO(
            symbol: symbol.rawValue,
            companyName: company.companyName,
            lastPrice: exchangeQuote.price.amount,
            currency: exchangeQuote.price.currency.rawValue,
            previousClose: exchangeQuote.previousClose.amount,
            marketCap: company.marketCap,
            isMarketOpen: exchangeQuote.isMarketOpen
        )
    }
}

private enum SearchRank: Comparable {
    case exactSymbol
    case symbolPrefix
    case companyName

    init?(of company: CompanyDTO, for query: String) {
        let symbol = company.symbol.rawValue
        let options: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        if symbol.compare(query, options: options) == .orderedSame {
            self = .exactSymbol
        } else if symbol.range(of: query, options: options.union(.anchored)) != nil {
            self = .symbolPrefix
        } else if company.companyName.range(of: query, options: options) != nil {
            self = .companyName
        } else {
            return nil
        }
    }
}

private enum FixtureFile: String {
    case companies
}
