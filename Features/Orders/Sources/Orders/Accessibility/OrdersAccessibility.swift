//
//  OrdersAccessibility.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface

enum OrdersAccessibility: String, AccessibilityIdentifying {
    case filterPicker = "orders.filterPicker"
    case orderRow = "orders.orderRow"
    case cancelButton = "orders.cancelButton"
    case stockButton = "orders.stockButton"
    case retryButton = "orders.retryButton"
    case pageRetryButton = "orders.pageRetryButton"
}
