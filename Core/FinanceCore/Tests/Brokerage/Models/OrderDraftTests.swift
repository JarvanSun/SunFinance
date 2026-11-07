//
//  OrderDraftTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct OrderDraftTests {
    @Test(arguments: [
        OrderDraft.make(.buy, .shares(2)),
        .make(.sell, .euros(250), execution: .limit(99.5)),
        .make(trigger: .priceAtOrAbove(120), validity: .goodTillCancelled),
        .make(.sell, trigger: .priceAtOrBelow(80)),
        .make(trigger: .at(Date(timeIntervalSince1970: 1_800_000_000))),
    ])
    func dtoThenMapsBackToTheSameDraft(draft: OrderDraft) throws {
        // When
        let roundTripped = try OrderDraft(draft.dto)

        // Then
        #expect(roundTripped == draft)
    }

    @Test func dtoThenWritesTheServersCodes() {
        // When
        let dto = OrderDraft.make(.sell, .euros(250), execution: .limit(99.5)).dto

        // Then
        #expect(dto.symbol == "SAP")
        #expect(dto.side == "sell")
        #expect(dto.shares == nil)
        #expect(dto.cashAmount == 250)
        #expect(dto.execution == "limit")
        #expect(dto.limitPrice == 99.5)
        #expect(dto.trigger == "now")
        #expect(dto.validity == "day")
    }

    @Test(arguments: [
        OrderDraftTests.dto(side: "hold"),
        OrderDraftTests.dto(shares: nil, cashAmount: nil),
        OrderDraftTests.dto(shares: 1, cashAmount: 100),
        OrderDraftTests.dto(execution: "limit"),
        OrderDraftTests.dto(execution: "iceberg"),
        OrderDraftTests.dto(trigger: "price_at_or_above"),
        OrderDraftTests.dto(trigger: "time"),
        OrderDraftTests.dto(validity: "forever"),
    ])
    func initWhenDTOIsInvalidThenThrowsDecoding(dto: OrderDraftDTO) {
        // When
        let result = Result { () throws(BrokerageError) in try OrderDraft(dto) }

        // Then
        #expect(result.failure == .decoding)
    }
}

private extension OrderDraftTests {
    static func dto(
        side: String = "buy",
        shares: Decimal? = 1,
        cashAmount: Decimal? = nil,
        execution: String = "market",
        trigger: String = "now",
        validity: String = "day"
    ) -> OrderDraftDTO {
        OrderDraftDTO(
            symbol: "SAP",
            side: side,
            shares: shares,
            cashAmount: cashAmount,
            execution: execution,
            limitPrice: nil,
            trigger: trigger,
            triggerPrice: nil,
            triggerTime: nil,
            validity: validity
        )
    }
}
