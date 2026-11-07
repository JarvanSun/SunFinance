//
//  PortfolioViewModelTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Portfolio

struct PortfolioViewModelTests {
    @Test func loadWhenItSucceedsThenKeepsTheChangePendingUntilTheChartIsLoaded() async throws {
        // Given
        let viewModel = makeViewModel()

        // When
        await viewModel.load()

        // Then
        let header = viewModel.header(of: try #require(viewModel.snapshot.value))
        #expect(viewModel.placeholder == nil)
        #expect(viewModel.positionsPlaceholder == nil)
        #expect(header.value == Money(4_000, .eur))
        #expect(header.change == .pending)
        #expect(header.moment == .range(.month))
    }

    @Test func loadWhenAReloadFailsThenKeepsTheBalancesAndGoesStale() async {
        // Given
        let brokerage = BrokerageStub()
        let viewModel = makeViewModel(brokerage: brokerage)
        await viewModel.load()

        // When
        brokerage.update { $0.accountResult = .failure(.offline) }
        await viewModel.load()

        // Then
        #expect(viewModel.placeholder == nil)
        #expect(viewModel.snapshot.value?.account == sampleAccount)
        #expect(viewModel.freshness == .stale(.offline))
        #expect(!viewModel.isLive)
    }

    @Test func placeholderBeforeLoadingThenShowsLoading() {
        // Given
        let viewModel = makeViewModel()

        // Then
        #expect(viewModel.placeholder == .loading)
        #expect(viewModel.positionsPlaceholder == nil)
    }

    @Test func positionsPlaceholderWhenNothingIsHeldThenIsEmpty() async {
        // Given
        let brokerage = BrokerageStub()
        brokerage.update { $0.portfolios = [Portfolio(open: [], closed: [])] }
        let viewModel = makeViewModel(brokerage: brokerage)

        // When
        await viewModel.load()

        // Then
        #expect(viewModel.placeholder == nil)
        #expect(viewModel.positionsPlaceholder == .empty)
        #expect(!viewModel.hasClosedPositions)
    }

    @Test func trackScreenViewWhenShownBeforeLoadingThenTracksOnceThePositionsAreKnown() async {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)

        // When
        viewModel.trackScreenView()
        let eventsBeforeLoading = tracker.events(of: PortfolioEvent.self)
        await viewModel.load()
        await viewModel.load()

        // Then
        #expect(eventsBeforeLoading.isEmpty)
        #expect(tracker.events(of: PortfolioEvent.self) == [.viewed(positionCount: 2)])
    }

    @Test func trackScreenViewWhenShownAgainThenTracksEachAppearance() async {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)
        await viewModel.load()

        // When
        viewModel.trackScreenView()
        viewModel.trackScreenView()

        // Then
        #expect(
            tracker.events(of: PortfolioEvent.self) == [
                .viewed(positionCount: 2), .viewed(positionCount: 2),
            ]
        )
    }

    @Test func loadWhenOfflineThenShowsTheIssue() async {
        // Given
        let brokerage = BrokerageStub()
        brokerage.update { $0.accountResult = .failure(.offline) }
        let viewModel = makeViewModel(brokerage: brokerage)

        // When
        await viewModel.load()

        // Then
        #expect(viewModel.placeholder == .failed(.offline))
    }

    @Test func headerWhenHistoryIsLoadedThenShowsTheChangeOverTheRange() async throws {
        // Given
        let viewModel = makeViewModel()
        await viewModel.load()

        // When
        await viewModel.loadHistory()

        // Then
        let header = viewModel.header(of: try #require(viewModel.snapshot.value))
        #expect(header.change == .known(Money(1_000, .eur), percent: Decimal(1_000) / 3_000 * 100))
        #expect(header.moment == .range(.month))
    }

    @Test func headerWhileANewRangeLoadsThenChangeIsPendingAndOldCurveStays() async throws {
        // Given
        let viewModel = makeViewModel()
        await viewModel.load()
        await viewModel.loadHistory()

        // When
        viewModel.selectRange(.year)

        // Then
        let header = viewModel.header(of: try #require(viewModel.snapshot.value))
        #expect(viewModel.history.shown == .loaded(sampleHistory))
        #expect(header.change == .pending)
        #expect(header.moment == .range(.year))
    }

    @Test func scrubWhileANewRangeLoadsThenDoesNotScrubTheOldCurve() async throws {
        // Given
        let viewModel = makeViewModel()
        await viewModel.load()
        await viewModel.loadHistory()
        viewModel.selectRange(.year)

        // When
        viewModel.scrub(to: Date(timeIntervalSince1970: 150))

        // Then
        let header = viewModel.header(of: try #require(viewModel.snapshot.value))
        #expect(header.value == Money(4_000, .eur))
        #expect(header.change == .pending)
    }

    @Test func loadHistoryWhenANewRangeFailsThenShowsTheFailureNotTheOldCurve() async {
        // Given
        let brokerage = BrokerageStub()
        let viewModel = makeViewModel(brokerage: brokerage)
        await viewModel.loadHistory()

        // When
        viewModel.selectRange(.year)
        brokerage.update { $0.historyResult = .failure(.offline) }
        await viewModel.loadHistory()

        // Then
        #expect(viewModel.history.shown == .failed(.offline))
    }

    @Test func scrubWhenHistoryIsLoadedThenShowsChangeSinceRangeStart() async throws {
        // Given
        let viewModel = makeViewModel()
        await viewModel.load()
        await viewModel.loadHistory()

        // When
        viewModel.scrub(to: Date(timeIntervalSince1970: 150))

        // Then
        let header = viewModel.header(of: try #require(viewModel.snapshot.value))
        #expect(header.value == Money(3_300, .eur))
        #expect(header.change == .known(Money(300, .eur), percent: 10))
        #expect(header.moment == .scrubbed(Date(timeIntervalSince1970: 100)))
    }

    @Test func keepFreshThenAppliesEachNewPortfolio() async {
        // Given
        let brokerage = BrokerageStub()
        let newer = Portfolio(open: [Position("SAP", value: 2_500, totalReturn: 700)], closed: [])
        brokerage.update { $0.portfolios = [samplePortfolio, newer] }
        let viewModel = makeViewModel(brokerage: brokerage)
        await viewModel.load()

        // When
        let refreshing = Task { await viewModel.keepFresh() }
        while viewModel.openPositions.count != 1 {
            await Task.yield()
        }
        refreshing.cancel()

        // Then
        #expect(viewModel.openPositions.first?.marketValue == Money(2_500, .eur))
    }

    @Test func keepFreshThenAppliesTheFirstPollInsteadOfFetchingTwiceOnAppearance() async {
        // Given
        let brokerage = BrokerageStub()
        let firstPoll = Portfolio(
            open: [Position("SAP", value: 2_500, totalReturn: 700)],
            closed: []
        )
        let secondPoll = Portfolio(
            open: [
                Position("SAP", value: 2_600, totalReturn: 800),
                Position("AAPL", value: 1_000, totalReturn: 0),
                Position("NVDA", value: 900, totalReturn: 0),
            ],
            closed: []
        )
        brokerage.update { $0.portfolios = [samplePortfolio, firstPoll, secondPoll] }
        let viewModel = makeViewModel(brokerage: brokerage)
        await viewModel.load()

        // When
        let refreshing = Task { await viewModel.keepFresh() }
        while viewModel.openPositions.count == 2 {
            await Task.yield()
        }
        let positionsAfterFirstPoll = viewModel.openPositions
        refreshing.cancel()

        // Then
        #expect(positionsAfterFirstPoll == firstPoll.open)
    }

    @Test func keepFreshWhenAPollFailsThenKeepsTheBalancesAndGoesStaleUntilTheNextPoll() async {
        // Given
        let brokerage = BrokerageStub()
        let newer = Portfolio(open: [Position("SAP", value: 2_500, totalReturn: 700)], closed: [])
        let viewModel = makeViewModel(brokerage: brokerage)
        await viewModel.load()
        brokerage.update { $0.portfolioFailure = .offline }

        // When
        let refreshing = Task { await viewModel.keepFresh() }
        while viewModel.isLive {
            await Task.yield()
        }
        let freshnessWhileFailing = viewModel.freshness
        let positionsWhileFailing = viewModel.openPositions.count
        brokerage.update {
            $0.portfolioFailure = nil
            $0.portfolios = [newer]
        }
        while !viewModel.isLive {
            await Task.yield()
        }
        refreshing.cancel()

        // Then
        #expect(freshnessWhileFailing == .stale(.offline))
        #expect(positionsWhileFailing == 2)
        #expect(viewModel.placeholder == nil)
        #expect(viewModel.openPositions.count == 1)
    }

    @Test func loadHistoryWhenARangeWasSeenThenShowsItEvenIfTheRefreshFails() async {
        // Given
        let brokerage = BrokerageStub()
        let viewModel = makeViewModel(brokerage: brokerage)
        await viewModel.loadHistory()
        viewModel.selectRange(.year)
        brokerage.update { $0.historyResult = .success(PortfolioHistory(range: .year, points: [])) }
        await viewModel.loadHistory()

        // When
        viewModel.selectRange(.month)
        brokerage.update { $0.historyResult = .failure(.offline) }
        await viewModel.loadHistory()

        // Then
        #expect(viewModel.history.shown == .loaded(sampleHistory))
    }

    @Test func loadHistoryWhenCancelledWhileAskingThenIgnoresTheLateAnswer() async {
        // Given
        let brokerage = BrokerageStub()
        brokerage.update { $0.historyDelay = .seconds(3_600) }
        let viewModel = makeViewModel(brokerage: brokerage)

        // When
        let loading = Task { await viewModel.loadHistory() }
        while brokerage.historyCalls == 0 {
            await Task.yield()
        }
        loading.cancel()
        await loading.value

        // Then
        #expect(viewModel.history.shown == .loading)
    }

    @Test func loadHistoryWhenItFailsFirstThenShowsTheIssue() async {
        // Given
        let brokerage = BrokerageStub()
        brokerage.update { $0.historyResult = .failure(.offline) }
        let viewModel = makeViewModel(brokerage: brokerage)

        // When
        await viewModel.loadHistory()

        // Then
        #expect(viewModel.history.shown == .failed(.offline))
    }

    @Test func loadHistoryWhenTheRangeChangedMeanwhileThenOnlyCachesTheOldRange() async {
        // Given
        let brokerage = BrokerageStub()
        brokerage.update { $0.historyDelay = .milliseconds(1) }
        let viewModel = makeViewModel(brokerage: brokerage)

        // When
        let loading = Task { await viewModel.loadHistory() }
        while brokerage.historyCalls == 0 {
            await Task.yield()
        }
        viewModel.selectRange(.year)
        await loading.value

        // Then
        #expect(viewModel.history.shown == .loading)
    }

    @Test func refreshThenLoadsBalancesAndChart() async {
        // Given
        let brokerage = BrokerageStub()
        let viewModel = makeViewModel(brokerage: brokerage)

        // When
        await viewModel.refresh()

        // Then
        #expect(viewModel.snapshot.value != nil)
        #expect(viewModel.history.shown == .loaded(sampleHistory))
    }

    @Test func selectSliceWhenTappedTwiceThenClearsIt() {
        // Given
        let viewModel = makeViewModel()

        // When
        viewModel.selectSlice("SAP")
        let first = viewModel.selectedSymbol
        viewModel.selectSlice("SAP")

        // Then
        #expect(first == "SAP")
        #expect(viewModel.selectedSymbol == nil)
    }

    @Test func openPositionThenTracksAndShowsQuoteDetail() {
        // Given
        let router = PortfolioRouterSpy()
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(router: router, tracker: tracker)

        // When
        viewModel.openPosition("SAP")

        // Then
        #expect(router.quoteDetails == ["SAP"])
        #expect(tracker.events(of: PortfolioEvent.self) == [.positionOpened("SAP")])
    }

    @Test(arguments: [(PositionAction.buyMore, TradeSide.buy), (.sell, .sell)])
    func performThenOpensTheTicketFromThePosition(action: PositionAction, side: TradeSide) {
        // Given
        let router = PortfolioRouterSpy()
        let viewModel = makeViewModel(router: router)

        // When
        viewModel.perform(action, on: "AAPL")

        // Then
        #expect(router.tickets == [TradeIntent(symbol: "AAPL", side: side, source: .position)])
    }

    @Test func selectRangeThenTracksAndClearsScrub() {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)
        viewModel.scrub(to: .now)

        // When
        viewModel.selectRange(.year)

        // Then
        #expect(viewModel.range == .year)
        #expect(viewModel.scrubbedMoment == nil)
        #expect(tracker.events(of: PortfolioEvent.self) == [.rangeChanged(.year)])
    }
}

private extension PortfolioViewModelTests {
    func makeViewModel(
        brokerage: BrokerageStub = BrokerageStub(),
        router: PortfolioRouterSpy = PortfolioRouterSpy(),
        tracker: AnalyticsTrackerSpy = AnalyticsTrackerSpy()
    ) -> PortfolioViewModel {
        PortfolioViewModel(
            accountProvider: brokerage,
            positionProvider: brokerage,
            historyProvider: brokerage,
            router: router,
            tracker: tracker,
            refreshInterval: .milliseconds(1)
        )
    }
}
