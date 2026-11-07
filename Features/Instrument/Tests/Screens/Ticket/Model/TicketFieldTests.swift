//
//  TicketFieldTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Instrument

struct TicketFieldTests {
    @Test(arguments: [
        (OrderRejection.insufficientCash, ExecutionKind.market, TicketField.amount),
        (.insufficientShares, .limit, .amount),
        (.invalidAmount, .market, .amount),
        (.unknownSymbol, .market, .amount),
        (.invalidPrice, .limit, .limitPrice),
        (.invalidPrice, .market, .triggerPrice),
        (.invalidSchedule, .market, .triggerTime),
    ])
    func initThenPicksTheFieldTheRejectionBelongsTo(
        rejection: OrderRejection,
        execution: ExecutionKind,
        expected: TicketField
    ) {
        // Then
        #expect(TicketField(rejection, execution: execution) == expected)
    }
}
