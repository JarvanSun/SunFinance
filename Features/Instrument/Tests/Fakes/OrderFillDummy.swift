//
//  OrderFillDummy.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension OrderFill {
    nonisolated static var dummy: OrderFill {
        Order.dummy(status: .filled).fill!
    }
}
