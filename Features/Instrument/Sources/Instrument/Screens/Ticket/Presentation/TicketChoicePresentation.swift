//
//  TicketChoicePresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension AmountMode {
    var segmentTitle: LocalizedStringResource {
        switch self {
        case .shares: .init("trading.amount.mode.shares", bundle: .module)
        case .euros: .init("trading.amount.mode.euros", bundle: .module)
        }
    }

    var fieldTitle: LocalizedStringResource {
        switch self {
        case .shares: .init("trading.amount.field.shares", bundle: .module)
        case .euros: .init("trading.amount.field.euros", bundle: .module)
        }
    }
}

extension ExecutionKind {
    var segmentTitle: LocalizedStringResource {
        switch self {
        case .market: .init("trading.execution.market", bundle: .module)
        case .limit: .init("trading.execution.limit", bundle: .module)
        }
    }
}

extension TriggerKind {
    var segmentTitle: LocalizedStringResource {
        switch self {
        case .now: .init("trading.trigger.now", bundle: .module)
        case .price: .init("trading.trigger.price", bundle: .module)
        case .time: .init("trading.trigger.time", bundle: .module)
        }
    }
}
