//
//  OrdersRouting.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

protocol OrdersRouting: AnyObject {
    func showDetail(of order: Order)
    func showQuoteDetail(for symbol: TickerSymbol)
}
