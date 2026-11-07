//
//  TradingMoment.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

enum TradingMoment {
    case tuesdayAfternoon
    case saturdayNoon
    case mondayMorning

    var date: Date {
        switch self {
        case .tuesdayAfternoon:
            Date(timeIntervalSince1970: 1_793_718_000)
        case .saturdayNoon:
            Date(timeIntervalSince1970: 1_794_052_800)
        case .mondayMorning:
            Date(timeIntervalSince1970: 1_794_232_800)
        }
    }
}
