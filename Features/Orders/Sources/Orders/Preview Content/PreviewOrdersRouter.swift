//
//  PreviewOrdersRouter.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore

final class PreviewOrdersRouter: OrdersRouting {
    func showDetail(of order: Order) {}

    func showQuoteDetail(for symbol: TickerSymbol) {}
}
#endif
