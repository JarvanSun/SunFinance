//
//  PriceLineChartStyleDummy.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import Foundation

extension PriceLineChartStyle {
    static var dummyAxisDate: @Sendable (Date) -> String {
        { $0.formatted(date: .omitted, time: .shortened) }
    }
}
#endif
