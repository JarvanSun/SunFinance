//
//  OrdersFooter.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum OrdersFooter: Equatable, Sendable {
    case loadingMore
    case failed(OrdersIssue)
}
