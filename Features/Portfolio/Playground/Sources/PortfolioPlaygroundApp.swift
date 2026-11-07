//
//  PortfolioPlaygroundApp.swift
//  PortfolioPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Portfolio
import SwiftUI

@main
struct PortfolioPlaygroundApp: App {
    private let brokerage = BrokerageService(
        environment: .mock(behavior: .realistic, storageDirectory: nil)
    )
    private let tracker = AnalyticsTracker(
        consent: UserDefaultsAnalyticsConsent(defaults: .standard),
        context: AnalyticsContext(appVersion: "playground", locale: .autoupdatingCurrent),
        destinations: [ConsoleAnalyticsDestination(subsystem: "PortfolioPlayground")]
    )

    var body: some Scene {
        WindowGroup {
            PortfolioHostView(
                dependencies: PortfolioDependencies(
                    accountProvider: brokerage,
                    positionProvider: brokerage,
                    historyProvider: brokerage,
                    tracker: tracker,
                    quoteDetail: FeatureEntry { Text(verbatim: "Quote detail: \($0.rawValue)") },
                    orderTicket: FeatureEntry {
                        Text(verbatim: "Order ticket: \($0.side.rawValue) \($0.symbol.rawValue)")
                    }
                )
            )
        }
    }
}
