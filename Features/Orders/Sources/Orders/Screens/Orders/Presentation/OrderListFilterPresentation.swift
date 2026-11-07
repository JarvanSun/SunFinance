//
//  OrderListFilterPresentation.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension OrderListFilter {
    var title: LocalizedStringResource {
        switch self {
        case .open: .init("orders.filter.open", bundle: .module)
        case .past: .init("orders.filter.past", bundle: .module)
        }
    }
}
