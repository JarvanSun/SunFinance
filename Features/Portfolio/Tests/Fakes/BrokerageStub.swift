//
//  BrokerageStub.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Synchronization

final class BrokerageStub: AccountProviding, PositionProviding, PortfolioHistoryProviding {
    struct State {
        var accountResult: Result<Account, BrokerageError> = .success(sampleAccount)
        var portfolios: [Portfolio] = [samplePortfolio]
        var portfolioFailure: BrokerageError?
        var historyResult: Result<PortfolioHistory, BrokerageError> = .success(sampleHistory)
        var historyDelay = Duration.zero
        var portfolioCalls = 0
        var historyCalls = 0
    }

    private let state = Mutex(State())

    var portfolioCalls: Int {
        state.withLock(\.portfolioCalls)
    }

    var historyCalls: Int {
        state.withLock(\.historyCalls)
    }

    func update(_ change: (inout State) -> Void) {
        state.withLock { state in change(&state) }
    }

    func account() async throws(BrokerageError) -> Account {
        try state.withLock(\.accountResult).get()
    }

    func portfolio() async throws(BrokerageError) -> Portfolio {
        let (portfolio, failure) = state.withLock { state in
            state.portfolioCalls += 1
            let portfolio =
                state.portfolios.count > 1 ? state.portfolios.removeFirst() : state.portfolios[0]
            return (portfolio, state.portfolioFailure)
        }
        if let failure { throw failure }
        return portfolio
    }

    func portfolioHistory(range: HistoryRange) async throws(BrokerageError) -> PortfolioHistory {
        let delay = state.withLock { state in
            state.historyCalls += 1
            return state.historyDelay
        }
        try? await Task.sleep(for: delay)
        return try state.withLock(\.historyResult).get()
    }
}
