//
//  ChartAccessibilityDummy.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

extension ChartAccessibility {
    static var dummy: ChartAccessibility {
        .init(
            title: "Sample",
            summary: "A sample price series",
            valueDescription: { $0.formatted(.currency(code: "USD")) },
            dateDescription: { $0.formatted(date: .abbreviated, time: .shortened) }
        )
    }
}
