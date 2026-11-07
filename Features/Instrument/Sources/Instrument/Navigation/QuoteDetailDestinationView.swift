//
//  QuoteDetailDestinationView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import SunUserInterface
import SwiftUI

struct QuoteDetailDestinationView: FeatureDestinationView {
    let destination: QuoteDetailDestination
    let orderTicket: (TradeIntent) -> TradingDependencies

    var style: PresentingStyle {
        switch destination {
        case .orderTicket:
            .sheet
        case .root:
            .push
        }
    }

    var body: some View {
        switch destination {
        case .root:
            EmptyView()
        case .orderTicket(let intent):
            TradingHostView(dependencies: orderTicket(intent))
        }
    }
}
