//
//  ChartRangePicker.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import SwiftUI

public struct ChartRangePicker: View {
    private let ranges: [HistoryRange]
    private let selection: HistoryRange
    private let onSelect: (HistoryRange) -> Void

    public init(
        ranges: [HistoryRange] = HistoryRange.allCases,
        selection: HistoryRange,
        onSelect: @escaping (HistoryRange) -> Void
    ) {
        self.ranges = ranges
        self.selection = selection
        self.onSelect = onSelect
    }

    public var body: some View {
        FinanceSegmentedControl(
            options: ranges,
            selection: selection,
            style: .quiet,
            onSelect: onSelect
        ) { range in
            Text(range.shortTitle)
                .accessibilityLabel(Text(range.accessibilityTitle))
        }
    }
}

#if DEBUG
private struct ChartRangePickerPreview: View {
    @State private var range = HistoryRange.day

    var body: some View {
        ChartRangePicker(selection: range, onSelect: { range = $0 })
            .padding()
    }
}

#Preview {
    ChartRangePickerPreview()
}
#endif
