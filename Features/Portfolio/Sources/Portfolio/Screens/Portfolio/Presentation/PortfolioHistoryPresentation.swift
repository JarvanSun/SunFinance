//
//  PortfolioHistoryPresentation.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension PortfolioHistory {
    var chartPoints: [ChartPoint] {
        points.map { ChartPoint(date: $0.date, value: $0.value.doubleValue) }
    }

    var baseline: Double? {
        points.first?.value.doubleValue
    }

    var chartAccessibility: ChartAccessibility {
        ChartAccessibility(
            title: .init("portfolio.chart.title", bundle: .module),
            summary: range.chartSummary(
                from: points.first?.value.formatted() ?? "",
                to: points.last?.value.formatted() ?? ""
            ),
            valueDescription: { Money(Decimal($0), .eur).formatted() },
            dateDescription: { $0.formatted(date: .abbreviated, time: .shortened) }
        )
    }
}
