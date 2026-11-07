//
//  QuoteConsole.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Observation

@Observable
final class QuoteConsole {
    private(set) var behavior: ConsoleBehavior = .realistic
    private(set) var outcome: ConsoleOutcome = .idle

    var searchQuery = "ap"

    private let symbols: [TickerSymbol]

    init(symbols: [TickerSymbol]) {
        self.symbols = symbols
    }

    func selectBehavior(_ behavior: ConsoleBehavior) {
        self.behavior = behavior
    }

    func fetchQuotes() async {
        await run { service, elapsed throws(MarketDataError) in
            .loaded(try await service.quotes(for: symbols), elapsed: elapsed())
        }
    }

    func searchSymbols() async {
        await run { [searchQuery] service, elapsed throws(MarketDataError) in
            .searched(try await service.symbols(matching: searchQuery), elapsed: elapsed())
        }
    }
}

private extension QuoteConsole {
    func run(
        _ call: (MarketDataService, () -> Duration) async throws(MarketDataError) -> ConsoleOutcome
    ) async {
        outcome = .loading
        let clock = ContinuousClock()
        let start = clock.now
        let result: ConsoleOutcome
        do {
            result = try await call(makeService()) { clock.now - start }
        } catch {
            result = .failed(error)
        }
        guard !Task.isCancelled else { return }

        outcome = result
    }

    func makeService() -> MarketDataService {
        .init(
            environment: .init(mockBehavior: behavior.mockBehavior, storageDirectory: nil)
        )
    }
}
