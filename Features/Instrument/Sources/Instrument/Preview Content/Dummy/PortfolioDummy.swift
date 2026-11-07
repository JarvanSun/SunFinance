//
//  PortfolioDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension Portfolio {
    nonisolated static var dummy: Portfolio {
        .init(open: [.dummy], closed: [])
    }
}
#endif
