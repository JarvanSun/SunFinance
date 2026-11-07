//
//  KeyStatisticsView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct KeyStatisticsView: View {
    @Environment(\.dimensions) private var dimensions

    let rows: [StatisticRow]

    var body: some View {
        VStack(alignment: .leading, spacing: dimensions.spaceLargeSmall) {
            SectionHeading(.init("quoteDetail.statistics.title", bundle: .module))

            MetricStrip(rows.map(\.metric))
        }
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 32) {
        KeyStatisticsView(rows: QuoteDetail.dummy.statisticRows)

        KeyStatisticsView(rows: QuoteDetail.dummy.statisticRows)
            .environment(\.locale, Locale(identifier: "de_DE"))
    }
    .padding()
}
#endif
