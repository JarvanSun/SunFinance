//
//  FinanceCorePlaygroundApp.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import SwiftUI

@main
struct FinanceCorePlaygroundApp: App {
    @State private var quoteConsole = QuoteConsole(
        symbols: ["AAPL", "MSFT", "NVDA", "SAP", "SIE", "ALV"]
    )
    @State private var brokerageConsole = BrokerageConsole()
    @State private var analyticsConsole = AnalyticsConsole()

    var body: some Scene {
        WindowGroup {
            TabView {
                Tab {
                    ExchangeConsoleView()
                } label: {
                    Text(verbatim: "Exchange")
                }

                Tab {
                    QuoteConsoleView(console: quoteConsole)
                } label: {
                    Text(verbatim: "MarketData")
                }

                Tab {
                    BrokerageConsoleView(console: brokerageConsole)
                } label: {
                    Text(verbatim: "Brokerage")
                }

                Tab {
                    AnalyticsConsoleView(console: analyticsConsole)
                } label: {
                    Text(verbatim: "Analytics")
                }
            }
        }
    }
}
