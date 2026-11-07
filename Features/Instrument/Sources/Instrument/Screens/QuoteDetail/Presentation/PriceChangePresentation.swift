//
//  PriceChangePresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension PriceChange {
    var trend: GainTrend {
        GainTrend(amount.amount)
    }

    var percentText: String {
        percent.formatted(.signedPercent)
    }

    var amountText: String {
        amount.formattedSigned()
    }
}
