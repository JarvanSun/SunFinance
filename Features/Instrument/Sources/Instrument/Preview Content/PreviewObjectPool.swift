//
//  PreviewObjectPool.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation
import SwiftUI

struct PreviewObjectPool {
    func quoteDetailDependencies() -> QuoteDetailDependencies {
        let marketData = PreviewMarketData(detailError: nil, historyError: nil, delay: .zero)
        let brokerage = PreviewBrokerage(isHolding: true)
        return .init(
            symbol: "AAPL",
            detailProvider: marketData,
            historyProvider: marketData,
            positionProvider: brokerage,
            orderProvider: brokerage,
            tracker: PreviewAnalyticsTracker(),
            orderTicket: tradingDependencies(for:)
        )
    }

    func quoteDetailViewModel(_ state: QuoteDetailPreviewState) -> QuoteDetailViewModel {
        let marketData = PreviewMarketData(
            detailError: state.detailError,
            historyError: state.historyError,
            delay: state.delay
        )
        let brokerage = PreviewBrokerage(isHolding: state.isHolding)
        return .init(
            symbol: "AAPL",
            detailProvider: marketData,
            historyProvider: marketData,
            positionProvider: brokerage,
            orderProvider: brokerage,
            router: PreviewQuoteDetailRouter(),
            tracker: PreviewAnalyticsTracker()
        )
    }

    func tradingDependencies(
        for intent: TradeIntent = .init(symbol: "AAPL", side: .buy, source: .quoteDetail)
    ) -> TradingDependencies {
        let services = PreviewServices()
        return .init(
            intent: intent,
            quoteProvider: services,
            accountProvider: services,
            positionProvider: services,
            previewer: services,
            placer: services,
            tracker: PreviewAnalyticsTracker()
        )
    }

    func ticketViewModel(_ state: TicketPreviewState) -> TicketViewModel {
        let services = PreviewServices(
            rejection: state.rejection,
            failure: state.failure,
            delay: state.delay,
            isMarketOpen: state.isMarketOpen
        )
        let viewModel = TicketViewModel(
            intent: TradeIntent(symbol: "AAPL", side: state.side, source: .quoteDetail),
            quoteProvider: services,
            accountProvider: services,
            positionProvider: services,
            previewer: services,
            router: PreviewTradingRouter(),
            tracker: PreviewAnalyticsTracker(),
            input: DecimalInput(locale: state.locale),
            estimateDelay: .zero,
            now: { Date() }
        )
        state.fill(viewModel)
        return viewModel
    }

    func reviewViewModel(_ state: ReviewPreviewState) -> ReviewViewModel {
        let services = PreviewServices(
            rejection: state.rejection,
            failure: state.failure,
            delay: state.delay
        )
        return .init(
            draft: .dummyLimit,
            previewer: services,
            placer: services,
            keys: PlacementKeys(),
            router: PreviewTradingRouter(),
            tracker: PreviewAnalyticsTracker()
        )
    }
}
#endif
