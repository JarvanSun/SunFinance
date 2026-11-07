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

enum PreviewObjectPool {
    static func quoteDetailDependencies() -> QuoteDetailDependencies {
        let marketData = PreviewMarketData(detailError: nil, historyError: nil, delay: .zero)
        let brokerage = PreviewBrokerage(isHolding: true)
        return QuoteDetailDependencies(
            symbol: "AAPL",
            detailProvider: marketData,
            historyProvider: marketData,
            positionProvider: brokerage,
            orderProvider: brokerage,
            tracker: PreviewAnalyticsTracker(),
            orderTicket: tradingDependencies(for:)
        )
    }

    static func quoteDetailViewModel(_ state: QuoteDetailPreviewState) -> QuoteDetailViewModel {
        let marketData = PreviewMarketData(
            detailError: state.detailError,
            historyError: state.historyError,
            delay: state.delay
        )
        let brokerage = PreviewBrokerage(isHolding: state.isHolding)
        return QuoteDetailViewModel(
            symbol: "AAPL",
            detailProvider: marketData,
            historyProvider: marketData,
            positionProvider: brokerage,
            orderProvider: brokerage,
            router: PreviewQuoteDetailRouter(),
            tracker: PreviewAnalyticsTracker()
        )
    }

    nonisolated static var detail: QuoteDetail {
        QuoteDetail(
            quote: quote(),
            open: Money(228.1, .usd),
            dayRange: 227.5...232.9,
            yearRange: 164.1...237.2,
            volume: 48_200_000
        )
    }

    nonisolated static func history(range: HistoryRange) -> PriceHistory {
        let start = Date(timeIntervalSince1970: 1_793_000_000)
        let candles = (0..<78).map { index in
            let open = Decimal(228 + sin(Double(index) / 7) * 3 + Double(index) * 0.04)
            return PriceCandle(
                start: start.addingTimeInterval(Double(index) * 300),
                open: open,
                high: open + 1,
                low: open - 1,
                close: open + 0.4,
                volume: 1_000
            )
        }
        return PriceHistory(
            symbol: "AAPL",
            range: range,
            currency: .usd,
            baseline: 228.5,
            candles: candles
        )
    }

    static var euroPosition: Position {
        Position(
            symbol: "SAP",
            quantity: 4.5,
            price: Money(221.35, .eur),
            averageCost: Money(230.1, .eur),
            averageLocalCost: Money(230.1, .eur),
            costBasis: Money(1_035.45, .eur),
            marketValue: Money(996.08, .eur),
            unrealizedGain: Money(-39.37, .eur),
            unrealizedGainPercent: -3.8,
            realizedGain: Money(12.4, .eur),
            todayGain: Money(-3.78, .eur),
            currencyEffect: Money(0, .eur),
            totalReturn: Money(-26.97, .eur),
            totalReturnPercent: -2.6
        )
    }

    static var trading: TradingSnapshot {
        TradingSnapshot(position: position, orders: [])
    }

    static func header(change: Decimal, moment: QuoteMoment) -> QuoteHeader {
        QuoteHeader(
            companyName: "Apple Inc.",
            price: Money(231.42 + change, .usd),
            change: .known(
                PriceChange(start: Money(231.42, .usd), end: Money(231.42 + change, .usd))
            ),
            moment: moment
        )
    }

    static func change(_ amount: Decimal) -> QuoteChange {
        header(change: amount, moment: .live(isMarketOpen: true)).change
    }

    static var pendingHeader: QuoteHeader {
        QuoteHeader(
            companyName: "Apple Inc.",
            price: Money(231.42, .usd),
            change: .pending,
            moment: .live(isMarketOpen: true)
        )
    }

    nonisolated static func quote(isMarketOpen: Bool = true) -> StockQuote {
        StockQuote(
            symbol: "AAPL",
            companyName: "Apple Inc.",
            price: Money(231.42, .usd),
            changePercent: 1.27,
            marketCap: Money(3_450_000_000_000, .usd),
            isMarketOpen: isMarketOpen
        )
    }

    nonisolated static var account: Account {
        Account(
            cash: Money(9_876.54, .eur),
            buyingPower: Money(9_876.54, .eur),
            positionsValue: Money(12_345.67, .eur),
            total: Money(22_222.21, .eur),
            todayGain: Money(84.2, .eur)
        )
    }

    nonisolated static var portfolio: Portfolio {
        Portfolio(open: [position], closed: [])
    }

    nonisolated static var position: Position {
        Position(
            symbol: "AAPL",
            quantity: 15,
            price: Money(231.42, .usd),
            averageCost: Money(182.1, .eur),
            averageLocalCost: Money(196.4, .usd),
            costBasis: Money(2_731.5, .eur),
            marketValue: Money(3_197.66, .eur),
            unrealizedGain: Money(466.16, .eur),
            unrealizedGainPercent: 17.07,
            realizedGain: Money(0, .eur),
            todayGain: Money(39.5, .eur),
            currencyEffect: Money(-41.3, .eur),
            totalReturn: Money(466.16, .eur),
            totalReturnPercent: 17.07
        )
    }

    nonisolated static func preview(rejection: OrderRejection?) -> OrderPreview {
        OrderPreview(
            quantity: 2,
            price: Money(231.42, .usd),
            exchangeRate: 0.9213,
            fee: Money(1, .eur),
            total: Money(427.42, .eur),
            cashAfter: Money(9_449.12, .eur),
            rejection: rejection
        )
    }

    nonisolated static func order(_ draft: OrderDraft, status: OrderStatus) -> Order {
        let fill = OrderFill(
            date: Date(timeIntervalSince1970: 1_793_718_000),
            quantity: 2,
            price: Money(231.42, .usd),
            exchangeRate: 0.9213,
            fee: Money(1, .eur),
            total: Money(427.42, .eur)
        )
        return Order(
            id: "preview",
            draft: draft,
            quantity: 2,
            currency: .usd,
            status: status,
            createdAt: fill.date,
            fill: status == .filled ? fill : nil
        )
    }

    nonisolated static var draft: OrderDraft {
        OrderDraft(
            symbol: "AAPL",
            side: .buy,
            amount: .shares(2),
            execution: .market,
            trigger: .immediately,
            validity: .day
        )
    }

    static func tradingDependencies(
        for intent: TradeIntent = TradeIntent(symbol: "AAPL", side: .buy, source: .quoteDetail)
    ) -> TradingDependencies {
        let services = PreviewServices()
        return TradingDependencies(
            intent: intent,
            quoteProvider: services,
            accountProvider: services,
            positionProvider: services,
            previewer: services,
            placer: services,
            tracker: PreviewAnalyticsTracker()
        )
    }

    nonisolated static func context(isMarketOpen: Bool) -> TicketContext {
        TicketContext(
            quote: quote(isMarketOpen: isMarketOpen),
            buyingPower: account.buyingPower,
            heldShares: position.quantity
        )
    }

    nonisolated static var outcomes: [OrderOutcome] {
        [
            .filled(order(draft, status: .filled).fill!),
            .waitingForPrice,
            .scheduled(Date(timeIntervalSince1970: 1_794_232_800)),
            .waitingForOpen,
            .cancelled,
            .rejected(.insufficientShares),
        ]
    }

    static func ticketViewModel(_ state: TicketPreviewState) -> TicketViewModel {
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

    static func reviewViewModel(_ state: ReviewPreviewState) -> ReviewViewModel {
        let services = PreviewServices(
            rejection: state.rejection,
            failure: state.failure,
            delay: state.delay
        )
        let draft = OrderDraft(
            symbol: "AAPL",
            side: .buy,
            amount: .shares(2),
            execution: .limit(235),
            trigger: .immediately,
            validity: .goodTillCancelled
        )
        return ReviewViewModel(
            draft: draft,
            previewer: services,
            placer: services,
            keys: PlacementKeys(),
            router: PreviewTradingRouter(),
            tracker: PreviewAnalyticsTracker()
        )
    }
}
#endif
