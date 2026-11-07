//
//  QuoteDTOFixtures.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

@testable import FinanceCore

extension QuoteDTO {
    static let apple = make()

    static let appleWithoutCompanyName = make(companyName: "")

    static let appleWithInvalidCurrency = make(currency: "DOLLAR")

    static let appleWithZeroPrice = make(lastPrice: 0)

    static let appleWithZeroPreviousClose = make(previousClose: 0)

    static func make(
        companyName: String = "Apple Inc.",
        lastPrice: Decimal = 228.52,
        currency: String = "USD",
        previousClose: Decimal = 200
    ) -> QuoteDTO {
        QuoteDTO(
            symbol: "AAPL",
            companyName: companyName,
            lastPrice: lastPrice,
            currency: currency,
            previousClose: previousClose,
            marketCap: 3_450_000_000_000,
            isMarketOpen: true
        )
    }
}
