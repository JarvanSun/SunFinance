//
//  PortfolioDummy.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension Portfolio {
    nonisolated static var dummy: Portfolio {
        .init(
            open: [
                .dummy("SAP", value: 2_000, totalReturn: 200),
                .dummy("AAPL", value: 1_000, totalReturn: -50),
            ],
            closed: [.dummy("KO", value: 0, totalReturn: 30, quantity: 0)]
        )
    }
}
