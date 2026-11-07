//
//  OrdersPlaceholder.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum OrdersPlaceholder: Equatable, Sendable {
    case loading
    case empty(OrderListFilter)
    case failed(OrdersIssue)
}
