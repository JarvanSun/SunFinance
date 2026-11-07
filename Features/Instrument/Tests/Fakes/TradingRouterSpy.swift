//
//  TradingRouterSpy.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

@testable import Instrument

final class TradingRouterSpy: TradingRouting {
    private(set) var reviewedDrafts: [OrderDraft] = []
    private(set) var returnCount = 0
    private(set) var closeCount = 0

    func showReview(of draft: OrderDraft) {
        reviewedDrafts.append(draft)
    }

    func returnToTicket() {
        returnCount += 1
    }

    func close() {
        closeCount += 1
    }
}
