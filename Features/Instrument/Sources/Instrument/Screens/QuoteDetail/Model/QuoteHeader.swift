//
//  QuoteHeader.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

struct QuoteHeader: Equatable, Sendable {
    let companyName: String
    let price: Money
    let change: QuoteChange
    let moment: QuoteMoment
}
