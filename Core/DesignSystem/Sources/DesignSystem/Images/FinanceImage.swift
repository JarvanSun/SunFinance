//
//  FinanceImage.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunUserInterface
import SwiftUI

public enum FinanceImage: String, CaseIterable, ImageStyling, Sendable {
    case favorite = "star.fill"
    case removeFavorite = "star.slash"
    case sort = "arrow.up.arrow.down"
    case search = "magnifyingglass"
    case offline = "wifi.slash"
    case warning = "exclamationmark.triangle"
    case emptyWatchlist = "chart.line.uptrend.xyaxis"
    case appMark = "chart.line.uptrend.xyaxis.circle.fill"
    case success = "checkmark.circle.fill"
    case scheduled = "clock"
    case rejected = "xmark"
    case buy = "plus"
    case sell = "minus"
    case slideToConfirm = "chevron.right.2"
    case confirmed = "checkmark"
    case watchlist = "list.star"
    case portfolio = "chart.pie"
    case orders = "clock.arrow.circlepath"

    public var definingBundle: Bundle { .designSystem }
}

#if DEBUG
#Preview("Images") {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(FinanceImage.allCases, id: \.self) { image in
                Label {
                    Text(verbatim: String(describing: image))
                } icon: {
                    Image(style: image)
                }
                .textStyle(FinanceColor.textPrimary, FinanceFont.body)
            }
        }
        .padding()
    }
}
#endif
