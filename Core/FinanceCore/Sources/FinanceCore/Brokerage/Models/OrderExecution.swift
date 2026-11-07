//
//  OrderExecution.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public enum OrderExecution: Hashable, Sendable {
    case market
    case limit(Decimal)
}
