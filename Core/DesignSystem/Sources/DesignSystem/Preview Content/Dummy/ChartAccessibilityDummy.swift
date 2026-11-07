//
//  ChartAccessibilityDummy.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import Foundation

extension ChartAccessibility {
    static var dummy: ChartAccessibility {
        .init(
            title: "Apple",
            summary: "Apple, one day, up 1.2 percent",
            valueDescription: { $0.formatted(.currency(code: "USD")) },
            dateDescription: { $0.formatted(date: .abbreviated, time: .shortened) }
        )
    }
}
#endif
