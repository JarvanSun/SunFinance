//
//  InstrumentPlaygroundApp.swift
//  InstrumentPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Instrument
import SwiftUI

@main
struct InstrumentPlaygroundApp: App {
    @State private var intent: TradeIntent?

    private let environment = ServerEnvironment(mockBehavior: .realistic, storageDirectory: nil)
    private let tracker = AnalyticsTracker(
        consent: UserDefaultsAnalyticsConsent(defaults: .standard),
        context: AnalyticsContext(appVersion: "playground", locale: .autoupdatingCurrent),
        destinations: [ConsoleAnalyticsDestination(subsystem: "InstrumentPlayground")]
    )

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List {
                    Section {
                        ForEach(TickerSymbol.dummySymbols, id: \.self) { symbol in
                            NavigationLink(value: symbol) {
                                Text(verbatim: symbol.rawValue)
                            }
                        }
                    } header: {
                        Text(verbatim: "Quote detail")
                    }

                    Section {
                        ForEach(TradeIntent.dummyIntents) { intent in
                            Button {
                                self.intent = intent
                            } label: {
                                Text(
                                    verbatim:
                                        "\(intent.side.rawValue.capitalized) \(intent.symbol.rawValue)"
                                )
                            }
                        }
                    } header: {
                        Text(verbatim: "Order ticket")
                    }
                }
                .navigationTitle(Text(verbatim: "Instrument"))
                .navigationDestination(for: TickerSymbol.self) { symbol in
                    QuoteDetailHostView(dependencies: quoteDetail(for: symbol))
                }
            }
            .sheet(item: $intent) { intent in
                TradingHostView(dependencies: trading(for: intent))
            }
        }
    }
}

private extension InstrumentPlaygroundApp {
    var marketData: MarketDataService {
        .init(environment: environment)
    }

    var brokerage: BrokerageService {
        .init(environment: environment)
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
