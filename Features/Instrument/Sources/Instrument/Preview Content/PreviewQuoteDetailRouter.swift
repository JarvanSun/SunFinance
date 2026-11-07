//
//  PreviewQuoteDetailRouter.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore

final class PreviewQuoteDetailRouter: QuoteDetailRouting {
    func showOrderTicket(for intent: TradeIntent, onDismiss: @escaping () -> Void) {}
}
#endif
