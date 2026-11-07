//
//  QuoteMoment.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

enum QuoteMoment: Equatable, Sendable {
    case live(isMarketOpen: Bool)
    case scrubbed(Date, HistoryRange)
}
