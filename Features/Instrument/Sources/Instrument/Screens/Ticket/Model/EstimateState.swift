//
//  EstimateState.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum EstimateState: Equatable, Sendable {
    case unavailable
    case loading(previous: OrderPreview?)
    case ready(OrderPreview)

    var preview: OrderPreview? {
        switch self {
        case .unavailable: nil
        case .loading(let previous): previous
        case .ready(let preview): preview
        }
    }
}
