//
//  OrderTrigger.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public enum OrderTrigger: Hashable, Sendable {
    case immediately
    case priceAtOrAbove(Decimal)
    case priceAtOrBelow(Decimal)
    case at(Date)
}
