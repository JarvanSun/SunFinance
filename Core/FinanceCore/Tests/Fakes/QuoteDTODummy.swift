//
//  QuoteDTODummy.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

@testable import FinanceCore

extension QuoteDTO {
    nonisolated static func dummy(
        companyName: String = "Apple Inc.",
        lastPrice: Decimal = 228.52,
        currency: String = "USD",
        previousClose: Decimal = 200
    ) -> QuoteDTO {
        .init(
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
