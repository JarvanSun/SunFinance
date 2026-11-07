//
//  CandleInterval.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

enum CandleInterval: Equatable, Sendable {
    case intraday(TimeInterval, sessions: Int)
    case sessions(Int, sessionsPerCandle: Int)

    init(_ range: HistoryRange) {
        switch range {
        case .day:
            self = .intraday(5 * 60, sessions: 1)
        case .week:
            self = .intraday(30 * 60, sessions: 5)
        case .month:
            self = .intraday(60 * 60, sessions: 22)
        case .threeMonths:
            self = .sessions(63, sessionsPerCandle: 1)
        case .year:
            self = .sessions(252, sessionsPerCandle: 1)
        case .fiveYears:
            self = .sessions(1_260, sessionsPerCandle: 5)
        }
    }
}
