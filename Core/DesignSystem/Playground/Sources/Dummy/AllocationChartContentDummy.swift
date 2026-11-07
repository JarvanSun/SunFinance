//
//  AllocationChartContentDummy.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

extension AllocationChartContent {
    static var dummy: AllocationChartContent {
        .init(
            slices: [
                AllocationSlice(id: "AAPL", label: "AAPL", value: 3_197),
                AllocationSlice(id: "NVDA", label: "NVDA", value: 2_610),
                AllocationSlice(id: "SAP", label: "SAP", value: 3_425),
                AllocationSlice(id: "cash", label: "Cash", value: 10_000, tone: .neutral),
            ],
            accessibility: AllocationChartAccessibility(
                title: "Allocation",
                summary: "Three holdings and cash"
            )
        )
    }
}
