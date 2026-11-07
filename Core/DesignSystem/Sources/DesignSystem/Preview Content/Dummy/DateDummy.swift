//
//  DateDummy.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import Foundation

extension Date {
    static var dummyChartStart: Date {
        .init(timeIntervalSince1970: 1_793_000_000)
    }
}
#endif
