//
//  DateDummy.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension Date {
    nonisolated static var dummyTuesdayAfternoon: Date {
        .init(timeIntervalSince1970: 1_793_718_000)
    }

    nonisolated static var dummySaturdayNoon: Date {
        .init(timeIntervalSince1970: 1_794_052_800)
    }

    nonisolated static var dummyMondayMorning: Date {
        .init(timeIntervalSince1970: 1_794_232_800)
    }
}
