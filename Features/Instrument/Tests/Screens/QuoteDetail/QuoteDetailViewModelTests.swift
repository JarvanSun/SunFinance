//
//  QuoteDetailViewModelTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct QuoteDetailViewModelTests {
    @Test func trackScreenViewThenTracksSymbol() {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)

        // When
        viewModel.trackScreenView()

        // Then
        #expect(tracker.events(of: QuoteDetailEvent.self) == [.screenViewed(symbol: "AAPL")])
    }

    @Test func titleAndCompanyNameBeforeLoadingThenUseTheSymbol() {
        // Given
        let viewModel = makeViewModel()

        // Then
        #expect(viewModel.title == "AAPL")
        #expect(viewModel.companyName == "AAPL")
    }

    @Test func placeholderBeforeLoadingThenIsLoading() {
        #expect(makeViewModel().placeholder == .loading)
    }

    @Test func reloadWhenItSucceedsThenShowsHeaderStatisticsAndCompany() async {
        // Given
        let viewModel = makeViewModel()

        // When
        await viewModel.reload()

        // Then
        #expect(viewModel.placeholder == nil)
        #expect(viewModel.header?.price == Money(110, .usd))
        #expect(viewModel.companyName == "Apple Inc.")
        #expect(viewModel.statisticRows.count == 5)
    }

    @Test func reloadWhenOfflineThenShowsOfflinePlaceholderWithoutTradeActions() async {
        // Given
        let viewModel = makeViewModel(marketData: MarketDataStub(detailResult: .failure(.offline)))

        // When
        await viewModel.reload()

        // Then
        #expect(viewModel.placeholder == .failed(.offline))
        #expect(viewModel.tradeActions.isEmpty)
    }

    @Test func reloadWhenCancelledThenChangesNothing() async {
        // Given
        let viewModel = makeViewModel()

        // When
        let task = Task { await viewModel.reload() }
        task.cancel()
        await task.value

        // Then
        #expect(viewModel.detail == .loading)
        #expect(viewModel.trading == .loading)
    }

    @Test func loadHistoryWhenCancelledThenKeepsLoading() async {
        // Given
        let viewModel = makeViewModel()

        // When
        let task = Task { await viewModel.loadHistory() }
        task.cancel()
        await task.value

        // Then
        #expect(viewModel.history.shown == .loading)
    }

    @Test func refreshThenLoadsDetailHistoryAndTrading() async {
        // Given
        let brokerage = BrokerageStub(
            portfolio: Portfolio(open: [.dummy(holding: "AAPL", quantity: 3)], closed: [])
        )
        let viewModel = makeViewModel(brokerage: brokerage)

        // When
        await viewModel.refresh()

        // Then
        #expect(viewModel.detail.value != nil)
        #expect(viewModel.history.shown.value?.range == .day)
        #expect(viewModel.position?.quantity == 3)
    }

    @Test func headerBeforeTheRangeLoadsThenChangeIsPending() async {
        // Given
        let viewModel = makeViewModel()

        // When
        await viewModel.reload()

        // Then
        #expect(viewModel.header?.change == .pending)
    }

    @Test func headerAfterHistoryThenComparesWithTheRangeBaseline() async {
        // Given
        let viewModel = makeViewModel()
        await viewModel.reload()

        // When
        await viewModel.loadHistory()

        // Then
        let expected = PriceChange(start: Money(100, .usd), end: Money(110, .usd))
        #expect(viewModel.header?.change == .known(expected))
    }

    @Test func headerWhileANewRangeLoadsThenChangeIsPendingAndOldCurveStays() async {
        // Given
        let viewModel = makeViewModel()
        await viewModel.reload()
        await viewModel.loadHistory()

        // When
        viewModel.selectRange(.year)

        // Then
        #expect(viewModel.history.shown.value?.range == .day)
        #expect(viewModel.header?.change == .pending)
    }

    @Test func loadHistoryForANewRangeThenShowsIt() async {
        // Given
        let viewModel = makeViewModel()
        await viewModel.loadHistory()

        // When
        viewModel.selectRange(.year)
        await viewModel.loadHistory()

        // Then
        #expect(viewModel.history.shown.value?.range == .year)
    }

    @Test func loadHistoryWhenANewRangeFailsThenShowsFailureNotTheOldCurve() async {
        // Given
        let marketData = MarketDataStub(failingRanges: [.year])
        let viewModel = makeViewModel(marketData: marketData)
        await viewModel.loadHistory()

        // When
        viewModel.selectRange(.year)
        await viewModel.loadHistory()

        // Then
        #expect(viewModel.history.shown == .failed(.serviceUnavailable))
    }

    @Test func loadHistoryWhenTheSameRangeFailsAgainThenKeepsItsCurve() async {
        // Given
        let marketData = MarketDataStub()
        let viewModel = makeViewModel(marketData: marketData)
        await viewModel.loadHistory()
        marketData.failingRanges = [.day]

        // When
        await viewModel.loadHistory()

        // Then
        #expect(viewModel.history.shown.value?.range == .day)
    }

    @Test func loadHistoryForACachedRangeThenShowsItBeforeTheAnswer() async {
        // Given
        let viewModel = makeViewModel()
        await viewModel.loadHistory()
        viewModel.selectRange(.year)
        await viewModel.loadHistory()
        viewModel.selectRange(.day)

        // When
        let task = Task { await viewModel.loadHistory() }
        task.cancel()
        await task.value

        // Then
        #expect(viewModel.history.shown.value?.range == .day)
    }

    @Test func historyRequestThenChangesWithRangeAndRetry() {
        // Given
        let viewModel = makeViewModel()
        let first = viewModel.historyRequest

        // When
        viewModel.selectRange(.month)
        let afterRange = viewModel.historyRequest
        viewModel.retry()

        // Then
        #expect(afterRange != first)
        #expect(viewModel.historyRequest != afterRange)
        #expect(viewModel.historyRequest.range == .month)
    }

    @Test func scrubThenHeaderShowsCandleCloseAndTracksOnlyWhenScrubEnds() async {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)
        await viewModel.reload()
        await viewModel.loadHistory()

        // When
        viewModel.scrub(to: Date(timeIntervalSince1970: 10))
        let scrubbedHeader = viewModel.header
        viewModel.scrub(to: Date(timeIntervalSince1970: 400))
        viewModel.scrub(to: nil)

        // Then
        let expected = PriceChange(start: Money(100, .usd), end: Money(105, .usd))
        #expect(scrubbedHeader?.price == Money(105, .usd))
        #expect(scrubbedHeader?.change == .known(expected))
        #expect(viewModel.header?.moment == .live(isMarketOpen: true))
        #expect(
            tracker.events(of: QuoteDetailEvent.self) == [
                .chartScrubbed(symbol: "AAPL", range: .day)
            ]
        )
    }

    @Test func selectRangeThenTracksResetsScrubAndIgnoresTheSameRange() {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)
        viewModel.scrub(to: Date(timeIntervalSince1970: 10))

        // When
        viewModel.selectRange(.year)
        viewModel.selectRange(.year)

        // Then
        #expect(viewModel.range == .year)
        #expect(viewModel.scrubbedMoment == nil)
        #expect(
            tracker.events(of: QuoteDetailEvent.self) == [
                .rangeChanged(symbol: "AAPL", range: .year)
            ]
        )
    }

    @Test func selectChartStyleWhenRangeIsShortThenStaysLine() {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)

        // When
        viewModel.selectChartStyle(.candles)

        // Then
        #expect(!viewModel.canShowCandles)
        #expect(viewModel.chartStyle == .line)
        #expect(tracker.events(of: QuoteDetailEvent.self).isEmpty)
    }

    @Test func selectChartStyleWhenRangeIsLongThenShowsCandlesUntilRangeIsShortAgain() {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)
        viewModel.selectRange(.threeMonths)

        // When
        viewModel.selectChartStyle(.candles)
        let longRangeStyle = viewModel.chartStyle
        viewModel.selectRange(.day)

        // Then
        #expect(longRangeStyle == .candles)
        #expect(viewModel.chartStyle == .line)
        #expect(tracker.events(of: QuoteDetailEvent.self).contains(.chartStyleChanged(.candles)))
    }

    @Test func openTicketThenRoutesWithTheQuoteDetailSource() {
        // Given
        let router = QuoteDetailRouterSpy()
        let viewModel = makeViewModel(router: router)

        // When
        viewModel.openTicket(.sell)

        // Then
        let expected = TradeIntent(symbol: "AAPL", side: .sell, source: .quoteDetail)
        #expect(router.shownIntents == [expected])
    }

    @Test func openTicketWhenTheTicketClosesThenReloads() throws {
        // Given
        let router = QuoteDetailRouterSpy()
        let viewModel = makeViewModel(router: router)
        let reloadRequest = viewModel.reloadRequest
        viewModel.openTicket(.buy)
        let closeTicket = try #require(router.onDismiss)

        // When
        closeTicket()

        // Then
        #expect(viewModel.reloadRequest != reloadRequest)
    }

    @Test func retryThenRequestsAReload() {
        // Given
        let viewModel = makeViewModel()
        let reloadRequest = viewModel.reloadRequest

        // When
        viewModel.retry()

        // Then
        #expect(viewModel.reloadRequest != reloadRequest)
    }

    @Test func tradeActionsWhenTheStockIsHeldThenOfferSellThenBuyAtThePrice() async {
        // Given
        let brokerage = BrokerageStub(
            portfolio: Portfolio(open: [.dummy(holding: "AAPL", quantity: 3)], closed: [])
        )
        let viewModel = makeViewModel(brokerage: brokerage)

        // When
        await viewModel.reload()

        // Then
        #expect(
            viewModel.tradeActions == [
                TradeAction(side: .sell, price: Money(110, .usd)),
                TradeAction(side: .buy, price: Money(110, .usd)),
            ]
        )
        #expect(viewModel.position?.quantity == 3)
    }

    @Test func tradeActionsWhenNothingIsHeldThenOfferBuyOnly() async {
        // Given
        let viewModel = makeViewModel(
            brokerage: BrokerageStub(
                portfolio: Portfolio(open: [.dummy(holding: "SAP", quantity: 3)], closed: [])
            )
        )

        // When
        await viewModel.reload()

        // Then
        #expect(viewModel.tradeActions.map(\.side) == [.buy])
        #expect(viewModel.position == nil)
    }

    @Test func reloadThenKeepsOnlyThisStocksOrders() async {
        // Given
        let brokerage = BrokerageStub(
            openOrders: [
                .dummy("AAPL", status: .waitingForPrice), .dummy("SAP", status: .waitingForPrice),
            ],
            pastOrders: [.dummy("AAPL", status: .filled, fillDate: .now)]
        )
        let viewModel = makeViewModel(brokerage: brokerage)

        // When
        await viewModel.reload()

        // Then
        #expect(viewModel.tradingSnapshot.orders.map(\.draft.symbol) == ["AAPL", "AAPL"])
    }

    @Test func reloadWhenTheSymbolHasMoreOrdersThanOnePageThenShowsThemAll() async {
        // Given
        let brokerage = BrokerageStub(
            openOrders: (0..<3).map { _ in .dummy("AAPL", status: .waitingForPrice) } + [
                .dummy("SAP", status: .waitingForPrice)
            ],
            pastOrders: (0..<3).map { _ in .dummy("AAPL", status: .filled, fillDate: .now) }
        )
        let viewModel = makeViewModel(brokerage: brokerage)

        // When
        await viewModel.reload()

        // Then
        let symbols = viewModel.tradingSnapshot.orders.map(\.draft.symbol)
        #expect(symbols == Array(repeating: "AAPL", count: 6))
    }

    @Test func reloadWhenBrokerageFailsThenShowsTheQuoteWithoutTrading() async {
        // Given
        let viewModel = makeViewModel(brokerage: BrokerageStub(failure: .offline))

        // When
        await viewModel.reload()

        // Then
        #expect(viewModel.trading == .failed(.offline))
        #expect(viewModel.tradingSnapshot == TradingSnapshot())
        #expect(viewModel.placeholder == nil)
        #expect(viewModel.tradeActions.map(\.side) == [.buy])
    }
}

private extension QuoteDetailViewModelTests {
    func makeViewModel(
        marketData: MarketDataStub = .init(),
        brokerage: BrokerageStub = .init(),
        router: QuoteDetailRouterSpy = .init(),
        tracker: AnalyticsTrackerSpy = .init()
    ) -> QuoteDetailViewModel {
        .init(
            symbol: "AAPL",
            detailProvider: marketData,
            historyProvider: marketData,
            positionProvider: brokerage,
            orderProvider: brokerage,
            router: router,
            tracker: tracker
        )
    }
}
