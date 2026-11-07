//
//  OrdersIssuePresentation.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

extension OrdersIssue {
    var title: LocalizedStringResource {
        switch self {
        case .offline:
            .init("orders.failure.offline.title", bundle: .module)
        case .serviceUnavailable:
            .init("orders.failure.service.title", bundle: .module)
        }
    }

    var message: LocalizedStringResource {
        switch self {
        case .offline:
            .init("orders.failure.offline.message", bundle: .module)
        case .serviceUnavailable:
            .init("orders.failure.service.message", bundle: .module)
        }
    }

    var image: FinanceImage {
        switch self {
        case .offline:
            .offline
        case .serviceUnavailable:
            .warning
        }
    }
}
