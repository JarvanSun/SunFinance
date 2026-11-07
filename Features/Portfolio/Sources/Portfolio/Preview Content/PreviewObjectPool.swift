//
//  PreviewObjectPool.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import DesignSystem
import FinanceCore
import Foundation
import SwiftUI

struct PreviewObjectPool {
    func portfolioDependencies() -> PortfolioDependencies {
        let services = PreviewBrokerage()
        return .init(
            accountProvider: services,
            positionProvider: services,
            historyProvider: services,
            tracker: PreviewAnalyticsTracker(),
            quoteDetail: FeatureEntry { Text(verbatim: "Quote detail \($0.rawValue)") },
            orderTicket: FeatureEntry {
                Text(verbatim: "Order ticket \($0.side) \($0.symbol.rawValue)")
            }
        )
    }

    func portfolioViewModel(_ state: PortfolioPreviewState) -> PortfolioViewModel {
        let services = PreviewBrokerage(
            isEmpty: state.isEmpty,
            failure: state.failure,
            delay: state.delay
        )
        return .init(
            accountProvider: services,
            positionProvider: services,
            historyProvider: services,
            router: PreviewPortfolioRouter(),
            tracker: PreviewAnalyticsTracker(),
            refreshInterval: .seconds(3_600)
        )
    }

}
#endif
