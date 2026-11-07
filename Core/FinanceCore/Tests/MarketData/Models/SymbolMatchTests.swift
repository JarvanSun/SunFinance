//
//  SymbolMatchTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct SymbolMatchTests {
    @Test func initThenMapsEveryField() throws {
        // When
        let match = try SymbolMatch(dto())

        // Then
        #expect(match.symbol == "SAP")
        #expect(match.id == "SAP")
        #expect(match.companyName == "SAP SE")
        #expect(match.exchange == "XETRA")
        #expect(match.currency == .eur)
    }

    @Test(arguments: [("", "XETRA", "EUR"), ("SAP SE", "", "EUR"), ("SAP SE", "XETRA", "EURO")])
    func initWhenDTOIsInvalidThenThrowsDecoding(name: String, exchange: String, currency: String) {
        // When
        let result = Result { () throws(MarketDataError) in
            try SymbolMatch(dto(companyName: name, exchange: exchange, currency: currency))
        }

        // Then
        #expect(result.failure == .decoding)
    }
}

private extension SymbolMatchTests {
    func dto(
        companyName: String = "SAP SE",
        exchange: String = "XETRA",
        currency: String = "EUR"
    ) -> SymbolMatchDTO {
        SymbolMatchDTO(
            symbol: "SAP",
            companyName: companyName,
            exchange: exchange,
            currency: currency
        )
    }
}
