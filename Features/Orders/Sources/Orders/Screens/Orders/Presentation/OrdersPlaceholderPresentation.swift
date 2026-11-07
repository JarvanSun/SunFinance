//
//  OrdersPlaceholderPresentation.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension OrdersPlaceholder {
    var title: LocalizedStringResource {
        switch self {
        case .loading: .init("orders.loading", bundle: .module)
        case .empty(.open): .init("orders.empty.open.title", bundle: .module)
        case .empty(.past): .init("orders.empty.past.title", bundle: .module)
        case .failed(let issue): issue.title
        }
    }

    var message: LocalizedStringResource {
        switch self {
        case .loading, .empty(.open): .init("orders.empty.open.message", bundle: .module)
        case .empty(.past): .init("orders.empty.past.message", bundle: .module)
        case .failed(let issue): issue.message
        }
    }

    var image: FinanceImage {
        switch self {
        case .loading, .empty: .scheduled
        case .failed(let issue): issue.image
        }
    }
}
