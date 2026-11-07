//
//  PortfolioHeaderPresentation.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import SwiftUI

extension PortfolioHeader {
    var trend: GainTrend {
        switch change {
        case .pending: .unchanged
        case .known(let amount, _): .init(amount.amount)
        }
    }

    var changeLabel: Text {
        switch moment {
        case .range(let range): .init(range.periodTitle)
        case .scrubbed(let date):
            .init(verbatim: date.formatted(.dateTime.day().month(.abbreviated).year()))
        }
    }

    var changeText: String {
        switch change {
        case .pending: reservedLine
        case .known(let amount, _): amount.formattedSigned()
        }
    }

    var changeValue: Double {
        switch change {
        case .pending: 0
        case .known(let amount, _): amount.doubleValue
        }
    }
}

private extension PortfolioHeader {
    var reservedLine: String { "\u{00A0}" }
}
