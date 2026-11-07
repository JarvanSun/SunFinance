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
        tracker = configuration.analyticsTracker
        tracker.applyConsent()
    }

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

    func portfolio() -> PortfolioDependencies {
        .init(
            accountProvider: brokerage,
            positionProvider: brokerage,
            historyProvider: brokerage,
            tracker: tracker,
            quoteDetail: quoteDetailEntry,
            orderTicket: orderTicketEntry
        )
    }

    func orders() -> OrdersDependencies {
        .init(
            orderProvider: brokerage,
            canceller: brokerage,
            tracker: tracker,
            quoteDetail: quoteDetailEntry
        )
    }

    func quoteDetail(for symbol: TickerSymbol) -> QuoteDetailDependencies {
        .init(
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
        .init(
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
        .init { QuoteDetailHostView(dependencies: quoteDetail(for: $0)) }
    }

    var orderTicketEntry: FeatureEntry<TradeIntent> {
        .init { TradingHostView(dependencies: trading(for: $0)) }
    }
}

private extension AppConfiguration {
    var analyticsTracker: AnalyticsTracker {
        .init(
            consent: UserDefaultsAnalyticsConsent(defaults: defaults),
            context: .init(
                appVersion: Bundle.main.string(for: .shortVersion),
                locale: .autoupdatingCurrent
            ),
            destinations: analyticsDestinations
        )
    }

    var analyticsDestinations: [AnalyticsDestination] {
        let vendor = VendorAnalyticsDestination(apiKey: vendorAnalyticsAPIKey)
        #if DEBUG
        return [
            vendor,
            ConsoleAnalyticsDestination(subsystem: Bundle.main.string(for: .bundleIdentifier)),
        ]
        #else
        return [vendor]
        #endif
    }
}

private extension Bundle {
    func string(for key: InfoKey) -> String {
        object(forInfoDictionaryKey: key.rawValue) as? String ?? ""
    }
}

private enum InfoKey: String {
    case shortVersion = "CFBundleShortVersionString"
    case bundleIdentifier = "CFBundleIdentifier"
}
