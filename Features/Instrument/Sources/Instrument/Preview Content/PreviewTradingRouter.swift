//
//  PreviewTradingRouter.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore

final class PreviewTradingRouter: TradingRouting {
    func showReview(of draft: OrderDraft) {}

    func returnToTicket() {}

    func close() {}
}
#endif
