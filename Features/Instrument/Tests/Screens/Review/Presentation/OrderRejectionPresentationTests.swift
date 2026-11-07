//
//  OrderRejectionPresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct OrderRejectionPresentationTests {
    @Test(arguments: [
        (OrderRejection.insufficientCash, "trading.rejection.insufficientCash"),
        (.insufficientShares, "trading.rejection.insufficientShares"),
        (.invalidAmount, "trading.rejection.invalidAmount"),
        (.invalidPrice, "trading.rejection.invalidPrice"),
        (.invalidSchedule, "trading.rejection.invalidSchedule"),
        (.unknownSymbol, "trading.rejection.unknownSymbol"),
    ])
    func messageThenGivesTheReason(rejection: OrderRejection, key: String) {
        #expect(rejection.message.key == key)
    }
}
