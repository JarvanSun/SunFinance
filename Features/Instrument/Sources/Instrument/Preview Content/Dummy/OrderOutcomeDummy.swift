//
//  OrderOutcomeDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension OrderOutcome {
    nonisolated static var dummyOutcomes: [OrderOutcome] {
        [
            .filled(Order.dummy(.dummyMarket, status: .filled).fill!),
            .waitingForPrice,
            .scheduled(.init(timeIntervalSince1970: 1_794_232_800)),
            .waitingForOpen,
            .cancelled,
            .rejected(.insufficientShares),
        ]
    }
}
#endif
