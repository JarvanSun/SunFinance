//
//  PreviewPortfolioRouter.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore

final class PreviewPortfolioRouter: PortfolioRouting {
    func showQuoteDetail(for symbol: TickerSymbol) {}

    func showOrderTicket(for intent: TradeIntent) {}
}
#endif
