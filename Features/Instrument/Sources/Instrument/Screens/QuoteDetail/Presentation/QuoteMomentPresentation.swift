//
//  QuoteMomentPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension QuoteMoment {
    var text: LocalizedStringResource {
        switch self {
        case .live(isMarketOpen: true): .init("quoteDetail.header.marketOpen", bundle: .module)
        case .live(isMarketOpen: false): .init("quoteDetail.header.marketClosed", bundle: .module)
        case .scrubbed(let date, .day):
            .init(
                "quoteDetail.header.atTime \(date.formatted(HistoryRange.day.momentStyle))",
                bundle: .module
            )
        case .scrubbed(let date, let range):
            .init("quoteDetail.header.onDate \(date.formatted(range.momentStyle))", bundle: .module)
        }
    }
}
