//
//  EstimateStatePresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore

extension EstimateState {
    var totalText: String {
        preview?.total.formatted() ?? placeholderText
    }

    var totalValue: Double {
        preview?.total.doubleValue ?? 0
    }

    var isRefreshing: Bool {
        switch self {
        case .loading:
            true
        case .unavailable, .ready:
            false
        }
    }

    var totalOpacity: Double {
        switch isRefreshing {
        case true:
            refreshingOpacity
        case false:
            1
        }
    }
}

private extension EstimateState {
    var refreshingOpacity: Double { 0.45 }

    var placeholderText: String { "–" }
}
