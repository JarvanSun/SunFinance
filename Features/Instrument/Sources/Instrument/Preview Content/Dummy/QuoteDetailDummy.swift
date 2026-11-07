//
//  QuoteDetailDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension QuoteDetail {
    nonisolated static var dummy: QuoteDetail {
        .init(
            quote: .dummy(),
            open: Money(228.1, .usd),
            dayRange: 227.5...232.9,
            yearRange: 164.1...237.2,
            volume: 48_200_000
        )
    }
}
#endif
