//
//  PositionPresentation.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension Position {
    var trend: GainTrend {
        GainTrend(totalReturn.amount)
    }

    var realizedTrend: GainTrend {
        GainTrend(realizedGain.amount)
    }

    var valueText: String {
        marketValue.formatted()
    }

    var returnText: String {
        totalReturnPercent.formatted(.signedPercent)
    }

    var realizedText: String {
        realizedGain.formattedSigned()
    }

    var accessibilityLabel: LocalizedStringResource {
        let price = price.formatted()
        return .init(
            "portfolio.position.accessibilityLabel \(symbol.rawValue) \(valueText) \(price) \(returnText)",
            bundle: .module
        )
    }

    var closedAccessibilityLabel: LocalizedStringResource {
        .init(
            "portfolio.closed.accessibilityLabel \(symbol.rawValue) \(realizedText)",
            bundle: .module
        )
    }
}
