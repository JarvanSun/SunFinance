//
//  AllocationSection.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct AllocationSection: View {
    @Environment(\.dimensions) private var dimensions

    let allocation: PortfolioAllocation
    let selection: TickerSymbol?
    let onSelect: (TickerSymbol?) -> Void

    var body: some View {
        AllocationChart(
            allocation.content,
            selection: selection?.rawValue,
            onSelect: { onSelect(allocation.symbol(forSlice: $0)) }
        ) { slice in
            VStack(spacing: dimensions.spaceXSmall) {
                allocation.centerTitle(for: slice)
                    .textStyle(FinanceColor.textSecondary, FinanceFont.caption)

                Text(verbatim: allocation.centerValue(for: slice))
                    .textStyle(FinanceColor.textPrimary, FinanceFont.headline)
                    .monospacedDigit()
                    .minimumScaleFactor(minimumScale)
                    .lineLimit(1)
            }
            .id(slice?.id)
            .transition(.identity)
        }
        .accessibilityIdentifier(PortfolioAccessibility.allocationChart)
    }
}

private extension AllocationSection {
    var minimumScale: CGFloat { 0.6 }
}
