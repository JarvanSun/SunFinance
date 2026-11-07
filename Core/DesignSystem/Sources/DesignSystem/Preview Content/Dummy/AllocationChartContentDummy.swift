//
//  AllocationChartContentDummy.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import Foundation

extension AllocationChartContent {
    static var dummy: AllocationChartContent {
        .init(
            slices: AllocationSlice.dummyAllocation,
            accessibility: AllocationChartAccessibility(
                title: "Allocation",
                summary: "Four holdings and cash, cash the largest at 49 percent"
            )
        )
    }
}
#endif
