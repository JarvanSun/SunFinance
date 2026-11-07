//
//  PortfolioHeaderView.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct PortfolioHeaderView: View {
    @Environment(\.dimensions) private var dimensions

    let header: PortfolioHeader

    var body: some View {
        VStack(alignment: .leading, spacing: dimensions.spaceSmall) {
            HeroAmount(header.value)

            HStack(alignment: .firstTextBaseline, spacing: dimensions.spaceSmall) {
                header.changeLabel
                    .textStyle(FinanceColor.textPrimary, FinanceFont.headline)

                Text(verbatim: header.changeText)
                    .textStyle(header.trend.color, FinanceFont.headline)
                    .monospacedDigit()
                    .contentTransition(.numericText(value: header.changeValue))
            }
            .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
