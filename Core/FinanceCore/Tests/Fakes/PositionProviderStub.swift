//
//  PositionProviderStub.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Synchronization

@testable import FinanceCore

final class PositionProviderStub: PositionProviding {
    private let results: Mutex<[Result<Portfolio, BrokerageError>]>
    private let callCount = Mutex(0)

    var calls: Int {
        callCount.withLock(\.self)
    }

    init(results: [Result<Portfolio, BrokerageError>]) {
        self.results = Mutex(results)
    }

    func portfolio() async throws(BrokerageError) -> Portfolio {
        callCount.withLock { $0 += 1 }
        let result = results.withLock { results in
            results.count > 1 ? results.removeFirst() : results[0]
        }
        return try result.get()
    }
}
