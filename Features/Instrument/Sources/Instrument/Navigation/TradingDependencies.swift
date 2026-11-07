//
//  TradingDependencies.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

public struct TradingDependencies {
    let intent: TradeIntent
    let quoteProvider: any QuoteProviding
    let accountProvider: any AccountProviding
    let positionProvider: any PositionProviding
    let previewer: any OrderPreviewing
    let placer: any OrderPlacing
    let tracker: any AnalyticsTracking
    let locale: Locale
    let estimateDelay: Duration
    let now: @Sendable () -> Date

    public init(
        intent: TradeIntent,
        quoteProvider: some QuoteProviding,
        accountProvider: some AccountProviding,
        positionProvider: some PositionProviding,
        previewer: some OrderPreviewing,
        placer: some OrderPlacing,
        tracker: some AnalyticsTracking,
        locale: Locale = .autoupdatingCurrent,
        estimateDelay: Duration = .milliseconds(350),
        now: @escaping @Sendable () -> Date = { Date() }
    ) {
        self.intent = intent
        self.quoteProvider = quoteProvider
        self.accountProvider = accountProvider
        self.positionProvider = positionProvider
        self.previewer = previewer
        self.placer = placer
        self.tracker = tracker
        self.locale = locale
        self.estimateDelay = estimateDelay
        self.now = now
    }

    func makeTicketViewModel(router: some TradingRouting) -> TicketViewModel {
        TicketViewModel(
            intent: intent,
            quoteProvider: quoteProvider,
            accountProvider: accountProvider,
            positionProvider: positionProvider,
            previewer: previewer,
            router: router,
            tracker: tracker,
            input: DecimalInput(locale: locale),
            estimateDelay: estimateDelay,
            now: now
        )
    }

    func makeReviewViewModel(
        draft: OrderDraft,
        keys: PlacementKeys,
        router: some TradingRouting
    ) -> ReviewViewModel {
        ReviewViewModel(
            draft: draft,
            previewer: previewer,
            placer: placer,
            keys: keys,
            router: router,
            tracker: tracker
        )
    }
}
