//
//  AllocationSliceDummy.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import Foundation

extension AllocationSlice {
    static var dummyAllocation: [AllocationSlice] {
        [
            .init(id: "AAPL", label: "AAPL", value: 3_197),
            .init(id: "NVDA", label: "NVDA", value: 2_610),
            .init(id: "SAP", label: "SAP", value: 3_425),
            .init(id: "ALV", label: "ALV", value: 1_390),
            .init(id: "cash", label: "Cash", value: 10_000, tone: .neutral),
        ]
    }
}
#endif
