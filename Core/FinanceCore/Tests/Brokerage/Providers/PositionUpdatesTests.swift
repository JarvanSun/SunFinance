//
//  PositionUpdatesTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct PositionUpdatesTests {
    @Test func portfolioUpdatesWhenAPollFailsThenYieldsTheFailureAndKeepsPolling() async throws {
        // Given
        let first = Portfolio(open: [], closed: [])
        let second = Portfolio(open: [], closed: [try Position(.make(symbol: "KO"))])
        let provider = PositionProviderStub(
            results: [.success(first), .failure(.offline), .success(second)]
        )

        // When
        var received: [Result<Portfolio, BrokerageError>] = []
        for await update in provider.portfolioUpdates(every: .zero) {
            received.append(update)
            guard received.count < 3 else { break }
        }

        // Then
        #expect(received == [.success(first), .failure(.offline), .success(second)])
    }

    @Test func portfolioUpdatesThenWaitsOneIntervalBeforeTheFirstPoll() async {
        // Given
        let provider = PositionProviderStub(results: [.success(Portfolio(open: [], closed: []))])

        // When
        let listening = Task {
            for await _ in provider.portfolioUpdates(every: .seconds(3_600)) {}
        }
        for _ in 0..<100 {
            await Task.yield()
        }
        listening.cancel()
        await listening.value

        // Then
        #expect(provider.calls == 0)
    }
}
