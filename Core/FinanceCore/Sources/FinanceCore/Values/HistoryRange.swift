//
//  HistoryRange.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum HistoryRange: String, CaseIterable, Codable, Sendable {
    case day = "1D"
    case week = "1W"
    case month = "1M"
    case threeMonths = "3M"
    case year = "1Y"
    case fiveYears = "5Y"
}
