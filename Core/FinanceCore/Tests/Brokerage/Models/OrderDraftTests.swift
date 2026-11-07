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
        OrderDraft.dummy(.buy, .shares(2)),
        .dummy(.sell, .euros(250), execution: .limit(99.5)),
        .dummy(trigger: .priceAtOrAbove(120), validity: .goodTillCancelled),
        .dummy(.sell, trigger: .priceAtOrBelow(80)),
        .dummy(trigger: .at(Date(timeIntervalSince1970: 1_800_000_000))),
    ])
    func dtoThenMapsBackToTheSameDraft(draft: OrderDraft) throws {
        // Given / When
        let roundTripped = try OrderDraft(draft.dto)

        // Then
        #expect(roundTripped == draft)
    }

    @Test func dtoThenWritesTheServersCodes() {
        // Given / When
        let dto = OrderDraft.dummy(.sell, .euros(250), execution: .limit(99.5)).dto

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
        OrderDraftDTO(side: "hold"),
        .init(shares: nil, cashAmount: nil),
        .init(shares: 1, cashAmount: 100),
        .init(execution: "limit"),
        .init(execution: "iceberg"),
        .init(trigger: "price_at_or_above"),
        .init(trigger: "time"),
        .init(validity: "forever"),
    ])
    func initWhenDTOIsInvalidThenThrowsDecoding(dto: OrderDraftDTO) {
        // Given / When
        let result = Result { () throws(BrokerageError) in try OrderDraft(dto) }

        // Then
        #expect(result.failure == .decoding)
    }
}

private extension OrderDraftDTO {
    init(
        side: String = "buy",
        shares: Decimal? = 1,
        cashAmount: Decimal? = nil,
        execution: String = "market",
        trigger: String = "now",
        validity: String = "day"
    ) {
        self.init(
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
