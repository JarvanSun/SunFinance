//
//  TicketIssue.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum TicketIssue: Hashable, Sendable {
    case missing
    case notANumber
    case notPositive
    case tooPrecise
    case notInFuture
    case tooFar
    case insufficientCash
    case insufficientShares
    case belowShareStep
    case notTradable
    case outsideSchedule

    init(_ rejection: OrderRejection) {
        switch rejection {
        case .insufficientCash:
            self = .insufficientCash
        case .insufficientShares:
            self = .insufficientShares
        case .invalidAmount:
            self = .belowShareStep
        case .invalidPrice:
            self = .notPositive
        case .invalidSchedule:
            self = .outsideSchedule
        case .unknownSymbol:
            self = .notTradable
        }
    }

    var waitsForReviewAttempt: Bool {
        self == .missing
    }
}
