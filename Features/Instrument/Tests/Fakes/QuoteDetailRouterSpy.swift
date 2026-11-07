//
//  QuoteDetailRouterSpy.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

@testable import Instrument

final class QuoteDetailRouterSpy: QuoteDetailRouting {
    private(set) var shownIntents: [TradeIntent] = []
    private(set) var onDismiss: (() -> Void)?

    func showOrderTicket(for intent: TradeIntent, onDismiss: @escaping () -> Void) {
        shownIntents.append(intent)
        self.onDismiss = onDismiss
    }
}
