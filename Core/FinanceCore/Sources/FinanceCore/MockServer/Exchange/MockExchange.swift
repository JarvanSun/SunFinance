//
//  MockExchange.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct MockExchange: Sendable {
    private let listings: [TickerSymbol: MockListing]
    private let eurPerUSD: Decimal

    public init() {
        let fixture = try? Bundle.module.fixture(
            named: FixtureFile.listings.rawValue,
            as: MockListingsDTO.self
        )
        self.init(listings: fixture?.listings ?? [], eurPerUSD: fixture?.eurPerUSD ?? 1)
    }

    init(listings: [MockListing], eurPerUSD: Decimal) {
        self.listings = Dictionary(listings.map { ($0.symbol, $0) }) { first, _ in first }
        self.eurPerUSD = eurPerUSD
    }

    public func quote(for symbol: TickerSymbol, at date: Date) -> ExchangeQuote? {
        guard let listing = listings[symbol] else { return nil }

        let isOpen = listing.venue.isOpen(at: date)
        let closes = listing.venue.closes(atOrBefore: date)
        let (priceMoment, comparedClose): (Date, Date?) =
            switch isOpen {
            case true:
                (date, closes.first)
            case false:
                (closes.first ?? date, closes.dropFirst().first)
            }
        return ExchangeQuote(
            price: price(of: listing, at: priceMoment),
            previousClose: price(of: listing, at: comparedClose ?? priceMoment),
            isMarketOpen: isOpen
        )
    }

    func venue(of symbol: TickerSymbol) -> TradingVenue? {
        listings[symbol]?.venue
    }

    public func eurRate(of currency: CurrencyCode, at date: Date) -> Decimal {
        guard currency != .eur else { return 1 }

        let drift = rateDrift * sin(2 * Double.pi * date.timeIntervalSince1970 / ratePeriod)
        return (eurPerUSD * Decimal(1 + drift)).rounded(to: ratePrecision)
    }

    func price(of symbol: TickerSymbol, at date: Date) -> Money? {
        listings[symbol].map { price(of: $0, at: date) }
    }

    func candles(for symbol: TickerSymbol, range: HistoryRange, endingAt date: Date)
        -> [ExchangeCandle]
    {
        guard let listing = listings[symbol] else { return [] }

        switch CandleInterval(range) {
        case .intraday(let length, let sessions):
            return listing.venue.sessions(endingAtOrBefore: date, count: sessions)
                .flatMap { intervals(in: $0, length: length) }
                .map { candle(of: listing, over: $0) }
        case .sessions(let sessions, let sessionsPerCandle):
            let sessions = listing.venue.sessions(endingAtOrBefore: date, count: sessions)
            return stride(from: 0, to: sessions.count, by: sessionsPerCandle)
                .map { Array(sessions[$0..<min($0 + sessionsPerCandle, sessions.count)]) }
                .map { candle(of: listing, over: $0) }
        }
    }
}

// MARK: - Private

private extension MockExchange {
    typealias Wave = (period: TimeInterval, amplitude: Double)

    var day: TimeInterval { 86_400 }

    var hour: TimeInterval { 3_600 }

    var waves: [Wave] {
        [
            (period: 263 * day, amplitude: 0.09),
            (period: 97 * day, amplitude: 0.05),
            (period: 11.3 * day, amplitude: 0.022),
            (period: 3.7 * day, amplitude: 0.008),
            (period: 22_000, amplitude: 0.004),
            (period: 5_820, amplitude: 0.0025),
            (period: 1_860, amplitude: 0.0012),
        ]
    }

    var pricePrecision: Int { 2 }

    var ratePrecision: Int { 4 }

    var rateDrift: Double { 0.03 }

    var ratePeriod: TimeInterval { 83 * day }

    var samplesPerCandle: Int { 8 }

    var baseVolume: Double { 400_000 }

    var volumeRhythmPeriod: TimeInterval { 7_919 }

    func intervals(in session: Range<Date>, length: TimeInterval) -> [Range<Date>] {
        stride(
            from: session.lowerBound.timeIntervalSince1970,
            to: session.upperBound.timeIntervalSince1970,
            by: length
        )
        .map { Date(timeIntervalSince1970: $0) }
        .map { $0..<min($0.addingTimeInterval(length), session.upperBound) }
    }

    func candle(of listing: MockListing, over interval: Range<Date>) -> ExchangeCandle {
        candle(of: listing, over: [interval])
    }

    func candle(of listing: MockListing, over intervals: [Range<Date>]) -> ExchangeCandle {
        let prices = intervals.flatMap { samples(in: $0) }.map { price(of: listing, at: $0).amount }
        let start = intervals.first?.lowerBound ?? .distantPast
        return .init(
            start: start,
            open: prices.first ?? listing.referencePrice,
            high: prices.max() ?? listing.referencePrice,
            low: prices.min() ?? listing.referencePrice,
            close: prices.last ?? listing.referencePrice,
            volume: volume(of: listing, over: intervals)
        )
    }

    func samples(in interval: Range<Date>) -> [Date] {
        let step =
            interval.upperBound.timeIntervalSince(interval.lowerBound) / Double(samplesPerCandle)
        return (0...samplesPerCandle).map {
            interval.lowerBound.addingTimeInterval(Double($0) * step)
        }
    }

    func volume(of listing: MockListing, over intervals: [Range<Date>]) -> Int {
        let hours =
            intervals.reduce(0) { $0 + $1.upperBound.timeIntervalSince($1.lowerBound) } / hour
        let rhythm =
            1
            + abs(
                sin(
                    Double(listing.symbol.stableSeed)
                        + (intervals.first?.lowerBound.timeIntervalSince1970 ?? 0)
                        / volumeRhythmPeriod
                )
            )
        return .init(baseVolume * listing.volatility * hours * rhythm)
    }

    func price(of listing: MockListing, at date: Date) -> Money {
        let seconds = date.timeIntervalSince1970
        let seed = Double(listing.symbol.stableSeed)
        let movement = waves.enumerated().reduce(0.0) { sum, wave in
            let phase = seed * Double(wave.offset + 1)
            let angle = 2 * Double.pi * seconds / wave.element.period + phase
            return sum + wave.element.amplitude * listing.volatility * sin(angle)
        }
        let amount = listing.referencePrice * Decimal(1 + movement)
        return .init(amount.rounded(to: pricePrecision), listing.currency)
    }
}

// MARK: - TickerSymbol

private extension TickerSymbol {
    var stableSeed: Int {
        rawValue.unicodeScalars.reduce(7) { ($0 * 31 + Int($1.value)) % 9_973 }
    }
}

// MARK: - Decimal

private extension Decimal {
    func rounded(to scale: Int) -> Decimal {
        var value = self
        var result = Decimal()
        NSDecimalRound(&result, &value, scale, .bankers)
        return result
    }
}

private enum FixtureFile: String {
    case listings
}
