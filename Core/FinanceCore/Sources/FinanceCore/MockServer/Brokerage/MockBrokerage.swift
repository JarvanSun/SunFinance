//
//  MockBrokerage.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Synchronization

final class MockBrokerage: Sendable {
    let exchange: MockExchange
    private let storageURL: URL?
    private let ledger: Mutex<MockLedger>

    init(exchange: MockExchange, storageURL: URL?, now: Date = .now) {
        self.exchange = exchange
        self.storageURL = storageURL
        let stored = storageURL.flatMap { try? Data(contentsOf: $0) }.flatMap {
            try? BackendCoding().decoder.decode(MockLedger.self, from: $0)
        }
        ledger = Mutex(stored ?? .init(seededAt: now, exchange: exchange))
    }

    func update<Result>(at date: Date, _ work: (inout MockLedger) -> Result) -> Result {
        let (result, snapshot) = ledger.withLock { ledger in
            ledger.settle(until: date, exchange: exchange)
            return (work(&ledger), ledger)
        }
        save(snapshot)
        return result
    }
}

private extension MockBrokerage {
    func save(_ ledger: MockLedger) {
        guard let storageURL, let data = try? BackendCoding().encoder.encode(ledger) else { return }

        try? FileManager.default.createDirectory(
            at: storageURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try? data.write(to: storageURL, options: .atomic)
    }
}
