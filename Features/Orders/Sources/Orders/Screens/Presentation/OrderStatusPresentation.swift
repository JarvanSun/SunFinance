//
//  OrderStatusPresentation.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension OrderStatus {
    var title: LocalizedStringResource {
        switch self {
        case .waitingForTrigger: .init("orders.status.waitingForTrigger", bundle: .module)
        case .waitingForPrice: .init("orders.status.waitingForPrice", bundle: .module)
        case .scheduled: .init("orders.status.scheduled", bundle: .module)
        case .waitingForOpen: .init("orders.status.waitingForOpen", bundle: .module)
        case .filled: .init("orders.status.filled", bundle: .module)
        case .cancelled: .init("orders.status.cancelled", bundle: .module)
        case .expired: .init("orders.status.expired", bundle: .module)
        case .rejected: .init("orders.status.rejected", bundle: .module)
        }
    }

    var image: FinanceImage {
        switch self {
        case .waitingForTrigger, .waitingForPrice, .scheduled, .waitingForOpen: .scheduled
        case .filled: .success
        case .cancelled, .expired, .rejected: .rejected
        }
    }

    var color: FinanceColor {
        switch self {
        case .waitingForTrigger, .waitingForPrice, .scheduled, .waitingForOpen: .accent
        case .filled: .gain
        case .cancelled, .expired: .textSecondary
        case .rejected: .critical
        }
    }
}
