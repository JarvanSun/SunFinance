//
//  PortfolioDummy.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension Portfolio {
    nonisolated static var dummy: Portfolio {
        .init(
            open: [
                .dummy("SAP", quantity: 15, value: 3_425, gain: 412.5),
                .dummy("AAPL", quantity: 15, value: 3_197, gain: 466.2),
                .dummy("NVDA", quantity: 15, value: 2_610, gain: -188.4),
                .dummy("ALV", quantity: 4, value: 1_390, gain: 22.8),
            ],
            closed: [.dummy("KO", quantity: 0, value: 0, gain: 96.3)]
        )
    }
}
#endif
