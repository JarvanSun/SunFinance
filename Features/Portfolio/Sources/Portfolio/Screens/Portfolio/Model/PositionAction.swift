//
//  PositionAction.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum PositionAction: CaseIterable, Hashable, Sendable {
    case buyMore
    case sell

    var side: TradeSide {
        switch self {
        case .buyMore: .buy
        case .sell: .sell
        }
    }
}
