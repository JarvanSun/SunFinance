//
//  TicketPlaceholder.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum TicketPlaceholder: Equatable, Sendable {
    case loading
    case failed(TradingIssue)
}
