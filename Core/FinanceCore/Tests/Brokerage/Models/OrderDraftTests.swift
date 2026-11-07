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
        OrderDraft(.buy, .shares(2)),
        .init(.sell, .euros(250), execution: .limit(99.5)),
        .init(trigger: .priceAtOrAbove(120), validity: .goodTillCancelled),
        .init(.sell, trigger: .priceAtOrBelow(80)),
        .init(trigger: .at(Date(timeIntervalSince1970: 1_800_000_000))),
    ])
    func dtoThenMapsBackToTheSameDraft(draft: OrderDraft) throws {
        // When
        let roundTripped = try OrderDraft(draft.dto)

        // Then
        #expect(roundTripped == draft)
    }

    @Test func dtoThenWritesTheServersCodes() {
        // When
        let dto = OrderDraft(.sell, .euros(250), execution: .limit(99.5)).dto

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
        makeDraftDTO(side: "hold"),
        makeDraftDTO(shares: nil, cashAmount: nil),
        makeDraftDTO(shares: 1, cashAmount: 100),
        makeDraftDTO(execution: "limit"),
        makeDraftDTO(execution: "iceberg"),
        makeDraftDTO(trigger: "price_at_or_above"),
        makeDraftDTO(trigger: "time"),
        makeDraftDTO(validity: "forever"),
    ])
    func initWhenDTOIsInvalidThenThrowsDecoding(dto: OrderDraftDTO) {
        // When
        let result = Result { () throws(BrokerageError) in try OrderDraft(dto) }

        // Then
        #expect(result.failure == .decoding)
    }
}

private func makeDraftDTO(
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
