//
//  OrderAmount.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public enum OrderAmount: Hashable, Sendable {
    case shares(Decimal)
    case euros(Decimal)
}
