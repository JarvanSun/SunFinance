//
//  PortfolioDestinationView.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct PortfolioDestinationView: FeatureDestinationView {
    let destination: PortfolioDestination
    let quoteDetail: FeatureEntry<TickerSymbol>
    let orderTicket: FeatureEntry<TradeIntent>

    var style: PresentingStyle {
        switch destination {
        case .orderTicket: .sheet
        case .root, .quoteDetail: .push
        }
    }

    var body: some View {
        switch destination {
        case .root:
            EmptyView()
        case .quoteDetail(let symbol):
            quoteDetail.view(for: symbol)
        case .orderTicket(let intent):
            orderTicket.view(for: intent)
        }
    }
}
