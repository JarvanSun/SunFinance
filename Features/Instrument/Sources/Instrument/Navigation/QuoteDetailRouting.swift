//
//  QuoteDetailRouting.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

protocol QuoteDetailRouting: AnyObject {
    func showOrderTicket(for intent: TradeIntent, onDismiss: @escaping () -> Void)
}
