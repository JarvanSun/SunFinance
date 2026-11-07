//
//  ExchangeConsoleView.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import SwiftUI

struct ExchangeConsoleView: View {
    @State private var hoursFromNow = 0.0

    private let exchange = MockExchange()
    private let symbols: [TickerSymbol] = [
        "AAPL", "MSFT", "NVDA", "TSLA", "KO", "JPM", "SAP", "SIE", "ALV",
    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Slider(value: $hoursFromNow, in: -168...168, step: 1)
                    Text(verbatim: moment.formatted(date: .abbreviated, time: .shortened))
                    Text(verbatim: "1 USD = \(exchange.eurRate(of: .usd, at: moment)) EUR")
                }

                Section {
                    ForEach(symbols, id: \.self) { symbol in
                        row(for: symbol)
                    }
                }
            }
            .navigationTitle(Text(verbatim: "Mock exchange"))
        }
    }

    private var moment: Date {
        Date.now.addingTimeInterval(hoursFromNow * 3_600)
    }

    private func row(for symbol: TickerSymbol) -> some View {
        let quote = exchange.quote(for: symbol, at: moment)
        return HStack {
            Text(verbatim: symbol.rawValue)
            Spacer()
            Text(
                verbatim: quote.map {
                    "\($0.price.amount.formatted(.number.precision(.fractionLength(2)))) \($0.price.currency.rawValue)"
                } ?? "–"
            )
            .monospacedDigit()
            Text(verbatim: quote?.isMarketOpen == true ? "open" : "closed")
                .foregroundStyle(.secondary)
        }
    }
}

#if DEBUG
#Preview {
    ExchangeConsoleView()
}
#endif
