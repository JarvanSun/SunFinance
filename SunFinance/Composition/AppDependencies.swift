//
//  AppDependencies.swift
//  SunFinance
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Instrument
import Orders
import Portfolio
import SwiftUI
import Watchlist

struct AppDependencies {
    private let configuration: AppConfiguration
    private let marketData: MarketDataService
    private let brokerage: BrokerageService
    private let watchlistStore: UserDefaultsWatchlistSymbolStore
    private let favoriteStore: UserDefaultsFavoriteSymbolStore
    private let tracker: AnalyticsTracker

    init(configuration: AppConfiguration) {
        let environment = ServerEnvironment(
            mockBehavior: configuration.serverBehavior,
            storageDirectory: configuration.mockServerStorageURL
        )
        self.configuration = configuration
        marketData = MarketDataService(environment: environment)
        brokerage = BrokerageService(environment: environment)
        watchlistStore = UserDefaultsWatchlistSymbolStore(
            defaults: configuration.defaults,
            defaultSymbols: configuration.defaultWatchlist
        )
        favoriteStore = UserDefaultsFavoriteSymbolStore(defaults: configuration.defaults)
        tracker = makeTracker(configuration: configuration)
        tracker.applyConsent()
    }

    func watchlist() -> WatchlistDependencies {
        WatchlistDependencies(
            watchlistStore: watchlistStore,
            quoteProvider: marketData,
            symbolSearcher: marketData,
            favoriteStore: favoriteStore,
            clock: ContinuousClock(),
            tracker: tracker,
            quoteDetail: quoteDetailEntry
        )
    }

    func portfolio() -> PortfolioDependencies {
        PortfolioDependencies(
            accountProvider: brokerage,
            positionProvider: brokerage,
            historyProvider: brokerage,
            tracker: tracker,
            quoteDetail: quoteDetailEntry,
            orderTicket: orderTicketEntry
        )
    }

    func orders() -> OrdersDependencies {
        OrdersDependencies(
            orderProvider: brokerage,
            canceller: brokerage,
            tracker: tracker,
            quoteDetail: quoteDetailEntry
        )
    }

    func quoteDetail(for symbol: TickerSymbol) -> QuoteDetailDependencies {
        QuoteDetailDependencies(
            symbol: symbol,
            detailProvider: marketData,
            historyProvider: marketData,
            positionProvider: brokerage,
            orderProvider: brokerage,
            tracker: tracker,
            orderTicket: trading(for:)
        )
    }

    func trading(for intent: TradeIntent) -> TradingDependencies {
        TradingDependencies(
            intent: intent,
            quoteProvider: marketData,
            accountProvider: brokerage,
            positionProvider: brokerage,
            previewer: brokerage,
            placer: brokerage,
            tracker: tracker
        )
    }
}

private extension AppDependencies {
    var quoteDetailEntry: FeatureEntry<TickerSymbol> {
        FeatureEntry { QuoteDetailHostView(dependencies: quoteDetail(for: $0)) }
    }

    var orderTicketEntry: FeatureEntry<TradeIntent> {
        FeatureEntry { TradingHostView(dependencies: trading(for: $0)) }
    }
}

private func info(_ key: InfoKey) -> String {
    Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String ?? ""
}

private func makeTracker(configuration: AppConfiguration) -> AnalyticsTracker {
    AnalyticsTracker(
        consent: UserDefaultsAnalyticsConsent(defaults: configuration.defaults),
        context: AnalyticsContext(
            appVersion: info(.shortVersion),
            locale: .autoupdatingCurrent
        ),
        destinations: analyticsDestinations(configuration: configuration)
    )
}

private func analyticsDestinations(configuration: AppConfiguration) -> [any AnalyticsDestination] {
    let vendor = VendorAnalyticsDestination(apiKey: configuration.vendorAnalyticsAPIKey)
    #if DEBUG
    return [vendor, ConsoleAnalyticsDestination(subsystem: info(.bundleIdentifier))]
    #else
    return [vendor]
    #endif
}

private enum InfoKey: String {
    case shortVersion = "CFBundleShortVersionString"
    case bundleIdentifier = "CFBundleIdentifier"
}
