//
//  PortfolioHeader.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct PortfolioHeader: Equatable {
    enum Moment: Equatable {
        case range(HistoryRange)
        case scrubbed(Date)
    }

    let value: Money
    let change: PortfolioChange
    let moment: Moment
}
