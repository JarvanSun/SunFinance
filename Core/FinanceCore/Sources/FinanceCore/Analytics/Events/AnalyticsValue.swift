//
//  AnalyticsValue.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public enum AnalyticsValue: Hashable, Sendable {
    case text(String)
    case integer(Int)
    case decimal(Decimal)
    case boolean(Bool)
}
