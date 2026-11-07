//
//  PortfolioAllocation.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import SwiftUI

struct PortfolioAllocation: Equatable {
    private enum SliceID: String {
        case cash
    }

    let slices: [AllocationSlice]

    init(account: Account, portfolio: Portfolio) {
        let holdings = portfolio.open.map {
            AllocationSlice(
                id: $0.symbol.rawValue,
                label: $0.symbol.rawValue,
                value: $0.marketValue.doubleValue
            )
        }
        let cash = AllocationSlice(
            id: SliceID.cash.rawValue,
            label: String(
                localized: LocalizedStringResource("portfolio.allocation.cash", bundle: .module)
            ),
            value: account.cash.doubleValue,
            tone: .neutral
        )
        slices = holdings + [cash]
    }

    var content: AllocationChartContent {
        .init(
            slices: slices,
            accessibility: .init(
                title: .init("portfolio.allocation.title", bundle: .module),
                summary: summary
            )
        )
    }

    func symbol(forSlice id: String?) -> TickerSymbol? {
        switch id {
        case .some(SliceID.cash.rawValue), nil: nil
        case .some(let id): TickerSymbol(rawValue: id)
        }
    }

    func swatch(for symbol: TickerSymbol) -> Color {
        switch slice(for: symbol) {
        case .some(let slice): AllocationPalette(slices: slices).color(of: slice)
        case nil: .clear
        }
    }

    func highlight(for symbol: TickerSymbol, selection: TickerSymbol?) -> Color {
        switch symbol == selection {
        case true: swatch(for: symbol).opacity(highlightOpacity)
        case false: .clear
        }
    }

    func centerTitle(for slice: AllocationSlice?) -> Text {
        switch slice {
        case .some(let slice): .init(verbatim: slice.label)
        case nil: .init("portfolio.allocation.positions", bundle: .module)
        }
    }

    func centerValue(for slice: AllocationSlice?) -> String {
        switch slice {
        case .some(let slice): share(of: slice)
        case nil: holdings.count.formatted()
        }
    }
}

private extension PortfolioAllocation {
    var highlightOpacity: Double { 0.12 }

    var holdings: [AllocationSlice] {
        slices.filter { $0.tone == .holding }
    }

    var total: Double {
        slices.reduce(0) { $0 + $1.value }
    }

    var summary: LocalizedStringResource {
        switch holdings.first {
        case .some(let largest):
            .init(
                "portfolio.allocation.summary \(largest.label) \(share(of: largest))",
                bundle: .module
            )
        case nil: .init("portfolio.allocation.summary.cashOnly", bundle: .module)
        }
    }

    func slice(for symbol: TickerSymbol) -> AllocationSlice? {
        slices.first { $0.id == symbol.rawValue }
    }

    func share(of slice: AllocationSlice) -> String {
        (slice.value / max(total, 1)).formatted(.percent.precision(.fractionLength(0)))
    }
}
