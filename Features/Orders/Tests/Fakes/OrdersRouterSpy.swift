//
//  OrdersRouterSpy.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

@testable import Orders

final class OrdersRouterSpy: OrdersRouting {
    private(set) var details: [Order] = []
    private(set) var stocks: [TickerSymbol] = []

    func showDetail(of order: Order) {
        details.append(order)
    }

    func showQuoteDetail(for symbol: TickerSymbol) {
        stocks.append(symbol)
    }
}
