//
//  DateDummy.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension Date {
    nonisolated static var dummyNow: Date {
        .init(timeIntervalSince1970: 1_793_718_000)
    }
}
