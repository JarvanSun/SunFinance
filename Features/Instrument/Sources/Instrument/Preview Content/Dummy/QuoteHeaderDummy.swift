//
//  QuoteHeaderDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension QuoteHeader {
    static func dummy(change: Decimal, moment: QuoteMoment) -> QuoteHeader {
        .init(
            companyName: "Apple Inc.",
            price: Money(231.42 + change, .usd),
            change: .known(
                PriceChange(start: Money(231.42, .usd), end: Money(231.42 + change, .usd))
            ),
            moment: moment
        )
    }

    static var dummyPending: QuoteHeader {
        .init(
            companyName: "Apple Inc.",
            price: Money(231.42, .usd),
            change: .pending,
            moment: .live(isMarketOpen: true)
        )
    }
}
#endif
