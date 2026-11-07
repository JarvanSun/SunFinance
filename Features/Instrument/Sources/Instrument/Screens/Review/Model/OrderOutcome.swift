//
//  OrderOutcome.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

enum OrderOutcome: Equatable, Sendable {
    case filled(OrderFill)
    case filledWithoutDetails
    case waitingForPrice
    case waitingForTrigger
    case scheduled(Date)
    case waitingForOpen
    case cancelled
    case expired
    case rejected(OrderRejection)

    init(_ order: Order) {
        switch (order.status, order.fill, order.draft.trigger) {
        case (.filled, .some(let fill), _):
            self = .filled(fill)
        case (.filled, nil, _):
            self = .filledWithoutDetails
        case (.scheduled, _, .at(let date)):
            self = .scheduled(date)
        case (.scheduled, _, _), (.waitingForOpen, _, _):
            self = .waitingForOpen
        case (.waitingForTrigger, _, _):
            self = .waitingForTrigger
        case (.waitingForPrice, _, _):
            self = .waitingForPrice
        case (.cancelled, _, _):
            self = .cancelled
        case (.expired, _, _):
            self = .expired
        case (.rejected(let rejection), _, _):
            self = .rejected(rejection)
        }
    }

    var allowsEditing: Bool {
        switch self {
        case .rejected, .cancelled, .expired: true
        case .filled, .filledWithoutDetails, .waitingForPrice, .waitingForTrigger, .scheduled,
            .waitingForOpen:
            false
        }
    }
}
