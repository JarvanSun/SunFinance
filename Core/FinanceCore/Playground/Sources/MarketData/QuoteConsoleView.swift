//
//  QuoteConsoleView.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct QuoteConsoleView: View {
    @State private var fetchRequest = 0
    @State private var searchRequest = 0

    @Bindable var console: QuoteConsole

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(selection: behaviorSelection) {
                        ForEach(ConsoleBehavior.allCases) { behavior in
                            Text(verbatim: behavior.rawValue).tag(behavior)
                        }
                    } label: {
                        Text(verbatim: "Mock server")
                    }

                    Button(action: { fetchRequest += 1 }) {
                        Text(verbatim: "Fetch quotes")
                    }
                    .buttonStyle(.finance(.primary))

                    TextField(text: $console.searchQuery) {
                        Text(verbatim: "Symbol or company")
                    }

                    Button(action: { searchRequest += 1 }) {
                        Text(verbatim: "Search symbols")
                    }
                    .buttonStyle(.finance(.secondary))
                }

                Section {
                    outcome
                } header: {
                    Text(verbatim: "QuoteProviding, SymbolSearching")
                }
            }
            .navigationTitle(Text(verbatim: "MarketData"))
            .task(id: fetchRequest) { await console.fetchQuotes() }
            .task(id: searchRequest) {
                guard searchRequest > 0 else { return }

                await console.searchSymbols()
            }
        }
    }
}

private extension QuoteConsoleView {
    var behaviorSelection: Binding<ConsoleBehavior> {
        Binding(get: { console.behavior }, set: { console.selectBehavior($0) })
    }

    @ViewBuilder
    var outcome: some View {
        switch console.outcome {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
        case .loaded(let quotes, let elapsed):
            Text(verbatim: "\(quotes.count) quotes in \(elapsed.formatted(.units(width: .narrow)))")
                .textStyle(FinanceColor.textSecondary, FinanceFont.caption)

            ForEach(quotes) { quote in
                QuoteLine(quote: quote)
            }
        case .searched(let matches, let elapsed):
            Text(verbatim: "\(matches.count) in \(elapsed.formatted(.units(width: .narrow)))")
                .textStyle(FinanceColor.textSecondary, FinanceFont.caption)

            ForEach(matches) { match in
                MatchLine(match: match)
            }
        case .failed(let error):
            Text(verbatim: "Failed: \(error)")
                .textStyle(FinanceColor.critical, FinanceFont.body)
        }
    }
}

private struct QuoteLine: View {
    let quote: StockQuote

    var body: some View {
        HStack {
            Text(verbatim: quote.symbol.rawValue)
                .textStyle(FinanceColor.textPrimary, FinanceFont.headline)

            Spacer()

            Text(quote.price.amount, format: .currency(code: quote.price.currency.rawValue))
                .textStyle(FinanceColor.textPrimary, FinanceFont.body)
                .monospacedDigit()

            Text(quote.changePercent, format: .signedPercent)
                .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
                .monospacedDigit()
        }
    }
}

private struct MatchLine: View {
    let match: SymbolMatch

    var body: some View {
        HStack {
            Text(verbatim: match.symbol.rawValue)
                .textStyle(FinanceColor.textPrimary, FinanceFont.headline)

            Text(verbatim: match.companyName)
                .textStyle(FinanceColor.textSecondary, FinanceFont.body)

            Spacer()

            Text(verbatim: "\(match.exchange) · \(match.currency.rawValue)")
                .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
        }
    }
}

#if DEBUG
#Preview {
    QuoteConsoleView(console: QuoteConsole(symbols: ["AAPL", "SAP"]))
}
#endif
