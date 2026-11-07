//
//  OrderTriggerSchedule.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension OrderTrigger {
    var scheduledTime: Date? {
        switch self {
        case .at(let time):
            time
        case .immediately, .priceAtOrAbove, .priceAtOrBelow:
            nil
        }
    }
}
