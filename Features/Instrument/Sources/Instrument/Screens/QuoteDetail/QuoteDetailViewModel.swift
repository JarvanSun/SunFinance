//
//  QuoteDetailViewModel.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Observation

@Observable
final class QuoteDetailViewModel {
    private(set) var detail: LoadState<QuoteDetail, QuoteDetailIssue> = .idle
    private(set) var history = RangedHistory<HistoryRange, PriceHistory, QuoteDetailIssue>(
        range: .day
    )
    private(set) var trading: LoadState<TradingSnapshot, QuoteDetailIssue> = .idle
    private(set) var preferredChartStyle = ChartStyle.line
    private(set) var scrubbedMoment: Date?
    private(set) var reloadRequest = UUID()

    var range: HistoryRange {
        history.range
    }

    var title: String {
        symbol.rawValue
    }

    var companyName: String {
        detail.value?.quote.companyName ?? symbol.rawValue
    }

    var historyRequest: HistoryRequest {
        HistoryRequest(range: range, reload: reloadRequest)
    }

    var canShowCandles: Bool {
        range.isLongEnoughForCandles
    }

    var chartStyle: ChartStyle {
        canShowCandles ? preferredChartStyle : .line
    }

    var header: QuoteHeader? {
        detail.value.map(header(for:))
    }

    var statisticRows: [StatisticRow] {
        detail.value?.statisticRows ?? []
    }

    var tradingSnapshot: TradingSnapshot {
        trading.value ?? .empty
    }

    var position: Position? {
        tradingSnapshot.position
    }

    var tradeActions: [TradeAction] {
        let price = detail.value?.quote.price
        return price.map { price in tradeSides.map { TradeAction(side: $0, price: price) } } ?? []
    }

    var placeholder: QuoteDetailPlaceholder? {
        switch detail {
        case .idle, .loading:
            .loading
        case .failed(let issue):
            .failed(issue)
        case .loaded:
            nil
        }
    }

    private let symbol: TickerSymbol
    private let detailProvider: any QuoteDetailProviding
    private let historyProvider: any PriceHistoryProviding
    private let positionProvider: any PositionProviding
    private let orderProvider: any OrderProviding
    private let router: any QuoteDetailRouting
    private let tracker: any AnalyticsTracking

    init(
        symbol: TickerSymbol,
        detailProvider: some QuoteDetailProviding,
        historyProvider: some PriceHistoryProviding,
        positionProvider: some PositionProviding,
        orderProvider: some OrderProviding,
        router: some QuoteDetailRouting,
        tracker: some AnalyticsTracking
    ) {
        self.symbol = symbol
        self.detailProvider = detailProvider
        self.historyProvider = historyProvider
        self.positionProvider = positionProvider
        self.orderProvider = orderProvider
        self.router = router
        self.tracker = tracker
    }

    func trackScreenView() {
        tracker.track(QuoteDetailEvent.screenViewed(symbol: symbol))
    }

    func reload() async {
        async let detail: Void = loadDetail()
        async let trading: Void = loadTrading()
        _ = await (detail, trading)
    }

    func refresh() async {
        async let detail: Void = loadDetail()
        async let history: Void = loadHistory()
        async let trading: Void = loadTrading()
        _ = await (detail, history, trading)
    }

    func loadHistory() async {
        let requested = range
        history.startLoading()
        let result = await fetchHistory(for: requested)
        guard !Task.isCancelled else { return }

        history.settle(with: result, for: requested)
    }

    func retry() {
        reloadRequest = UUID()
    }

    func selectRange(_ newRange: HistoryRange) {
        guard newRange != range else { return }

        history.select(newRange)
        scrubbedMoment = nil
        tracker.track(QuoteDetailEvent.rangeChanged(symbol: symbol, range: newRange))
    }

    func selectChartStyle(_ style: ChartStyle) {
        guard style != preferredChartStyle, canShowCandles else { return }

        preferredChartStyle = style
        tracker.track(QuoteDetailEvent.chartStyleChanged(style))
    }

    func scrub(to moment: Date?) {
        let endsScrub = scrubbedMoment != nil && moment == nil
        scrubbedMoment = moment
        guard endsScrub else { return }

        tracker.track(QuoteDetailEvent.chartScrubbed(symbol: symbol, range: range))
    }

    func openTicket(_ side: TradeSide) {
        let intent = TradeIntent(symbol: symbol, side: side, source: .quoteDetail)
        router.showOrderTicket(for: intent) { [weak self] in self?.retry() }
    }
}

// MARK: - Private

private extension QuoteDetailViewModel {
    typealias PortfolioResult = Result<Portfolio, BrokerageError>
    typealias OrdersResult = Result<[Order], BrokerageError>

    var tradeSides: [TradeSide] {
        switch position?.isOpen {
        case .some(true):
            [.sell, .buy]
        case .some(false), nil:
            [.buy]
        }
    }

    var scrubbedCandle: PriceCandle? {
        scrubbedMoment.flatMap { moment in history.selected?.candles.last { $0.start <= moment } }
    }

    func header(for detail: QuoteDetail) -> QuoteHeader {
        let quote = detail.quote
        return switch scrubbedCandle {
        case .some(let candle):
            QuoteHeader(
                companyName: quote.companyName,
                price: Money(candle.close, quote.price.currency),
                change: change(to: candle.close),
                moment: .scrubbed(candle.start, range)
            )
        case nil:
            QuoteHeader(
                companyName: quote.companyName,
                price: quote.price,
                change: change(to: quote.price.amount),
                moment: .live(isMarketOpen: quote.isMarketOpen)
            )
        }
    }

    func change(to price: Decimal) -> QuoteChange {
        switch history.selected?.change(to: price) {
        case .some(let change):
            .known(change)
        case nil:
            .pending
        }
    }

    func loadDetail() async {
        detail = detail.reloading
        let result = await fetchDetail()
        guard !Task.isCancelled else { return }

        detail = detail.settled(with: result)
    }

    func loadTrading() async {
        trading = trading.reloading
        let result = await fetchTrading()
        guard !Task.isCancelled else { return }

        trading = trading.settled(with: result)
    }

    func fetchDetail() async -> LoadState<QuoteDetail, QuoteDetailIssue> {
        do {
            return .loaded(try await detailProvider.quoteDetail(for: symbol))
        } catch {
            return .failed(QuoteDetailIssue(error))
        }
    }

    func fetchHistory(for range: HistoryRange) async -> LoadState<PriceHistory, QuoteDetailIssue> {
        do {
            return .loaded(try await historyProvider.priceHistory(for: symbol, range: range))
        } catch {
            return .failed(QuoteDetailIssue(error))
        }
    }

    func fetchTrading() async -> LoadState<TradingSnapshot, QuoteDetailIssue> {
        async let portfolio = fetchPortfolio()
        async let openOrders = fetchOrders(.open)
        async let pastOrders = fetchOrders(.past)
        return switch await (portfolio, openOrders, pastOrders) {
        case (.success(let portfolio), .success(let open), .success(let past)):
            .loaded(
                TradingSnapshot(
                    symbol: symbol,
                    portfolio: portfolio,
                    orders: open + past
                )
            )
        case (.failure(let error), _, _), (_, .failure(let error), _), (_, _, .failure(let error)):
            .failed(QuoteDetailIssue(error))
        }
    }

    func fetchPortfolio() async -> PortfolioResult {
        do {
            return .success(try await positionProvider.portfolio())
        } catch {
            return .failure(error)
        }
    }

    func fetchOrders(_ filter: OrderListFilter) async -> OrdersResult {
        do {
            return .success(try await orderProvider.allOrders(filter, for: symbol))
        } catch {
            return .failure(error)
        }
    }
}
