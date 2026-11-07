//
//  ExchangeQuote.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct ExchangeQuote: Equatable, Sendable {
    public let price: Money
    let previousClose: Money
    public let isMarketOpen: Bool
}
