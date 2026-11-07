//
//  TradingSnapshotDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension TradingSnapshot {
    static var dummy: TradingSnapshot {
        .init(position: .dummy, orders: [])
    }
}
#endif
