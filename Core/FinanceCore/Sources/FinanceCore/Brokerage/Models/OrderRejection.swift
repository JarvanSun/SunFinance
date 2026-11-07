//
//  OrderRejection.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum OrderRejection: String, CaseIterable, Hashable, Sendable {
    case insufficientCash = "insufficient_cash"
    case insufficientShares = "insufficient_shares"
    case invalidAmount = "invalid_amount"
    case invalidPrice = "invalid_price"
    case invalidSchedule = "invalid_schedule"
    case unknownSymbol = "unknown_symbol"
}
