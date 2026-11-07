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
    let quoteProvider: QuoteProviding
    let accountProvider: AccountProviding
    let positionProvider: PositionProviding
    let previewer: OrderPreviewing
    let placer: OrderPlacing
    let tracker: AnalyticsTracking
    let locale: Locale
    let estimateDelay: Duration
    let now: @Sendable () -> Date

    public init(
        intent: TradeIntent,
        quoteProvider: QuoteProviding,
        accountProvider: AccountProviding,
        positionProvider: PositionProviding,
        previewer: OrderPreviewing,
        placer: OrderPlacing,
        tracker: AnalyticsTracking,
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

    func makeTicketViewModel(router: TradingRouting) -> TicketViewModel {
        .init(
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
        router: TradingRouting
    ) -> ReviewViewModel {
        .init(
            draft: draft,
            previewer: previewer,
            placer: placer,
            keys: keys,
            router: router,
            tracker: tracker
        )
    }
}
