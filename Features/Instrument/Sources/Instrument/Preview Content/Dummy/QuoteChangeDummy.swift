//
//  QuoteChangeDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension QuoteChange {
    static func dummy(_ amount: Decimal) -> QuoteChange {
        QuoteHeader.dummy(change: amount, moment: .live(isMarketOpen: true)).change
    }
}
#endif
