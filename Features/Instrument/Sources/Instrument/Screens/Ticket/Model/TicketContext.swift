//
//  TicketContext.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct TicketContext: Equatable {
    let quote: StockQuote
    let buyingPower: Money
    let heldShares: Decimal
}
