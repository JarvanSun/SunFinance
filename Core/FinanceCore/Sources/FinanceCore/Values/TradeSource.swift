//
//  TradeSource.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum TradeSource: String, CaseIterable, Hashable, Sendable {
    case quoteDetail = "quote_detail"
    case position
}
