//
//  CashEntry.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct CashEntry: Codable, Equatable, Sendable {
    let date: Date
    let amount: Decimal
}
