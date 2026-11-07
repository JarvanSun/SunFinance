//
//  TradingRouting.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

protocol TradingRouting: AnyObject {
    func showReview(of draft: OrderDraft)
    func returnToTicket()
    func close()
}
