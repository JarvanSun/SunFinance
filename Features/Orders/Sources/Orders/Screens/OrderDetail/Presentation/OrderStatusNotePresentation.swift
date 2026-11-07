//
//  OrderStatusNotePresentation.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension OrderStatusNote {
    init(_ status: OrderStatus) {
        switch status {
        case .waitingForTrigger:
            self = .waiting(.init("orders.status.detail.waitingForTrigger", bundle: .module))
        case .waitingForPrice:
            self = .waiting(.init("orders.status.detail.waitingForPrice", bundle: .module))
        case .scheduled:
            self = .waiting(.init("orders.status.detail.scheduled", bundle: .module))
        case .waitingForOpen:
            self = .waiting(.init("orders.status.detail.waitingForOpen", bundle: .module))
        case .rejected(let rejection):
            self = .rejected(rejection.message)
        case .filled, .cancelled, .expired:
            self = .none
        }
    }
}
