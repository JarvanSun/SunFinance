//
//  OrderExecutionMatching.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension OrderExecution {
    func allowsFill(at price: Decimal, side: TradeSide) -> Bool {
        switch (self, side) {
        case (.market, _): true
        case (.limit(let limit), .buy): price <= limit
        case (.limit(let limit), .sell): price >= limit
        }
    }
}
