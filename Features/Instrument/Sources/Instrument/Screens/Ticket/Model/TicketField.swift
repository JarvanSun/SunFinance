//
//  TicketField.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum TicketField: CaseIterable, Hashable, Sendable {
    case amount
    case limitPrice
    case triggerPrice
    case triggerTime

    init(_ rejection: OrderRejection, execution: ExecutionKind) {
        switch (rejection, execution) {
        case (.insufficientCash, _), (.insufficientShares, _), (.invalidAmount, _),
            (.unknownSymbol, _):
            self = .amount
        case (.invalidPrice, .limit):
            self = .limitPrice
        case (.invalidPrice, .market):
            self = .triggerPrice
        case (.invalidSchedule, _):
            self = .triggerTime
        }
    }
}
