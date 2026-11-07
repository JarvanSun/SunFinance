//
//  TicketViewModelTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct TicketViewModelTests {
    @Test func loadWhenItSucceedsThenKnowsCashAndShares() async {
        // Given
        let viewModel = makeViewModel()

        // When
        await viewModel.load()

        // Then
        #expect(viewModel.placeholder == nil)
        #expect(viewModel.context.value?.heldShares == 15)
        #expect(viewModel.sides == [.buy, .sell])
    }

    @Test func loadWhenNothingIsHeldThenOffersBuyOnly() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.portfolioResult = .success(.dummy(holdingApple: 0)) }
        let viewModel = makeViewModel(services: services)

        // When
        await viewModel.load()

        // Then
        #expect(viewModel.sides == [.buy])
    }

    @Test func loadWhenOfflineThenShowsTheIssue() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.accountResult = .failure(.offline) }
        let viewModel = makeViewModel(services: services)

        // When
        await viewModel.load()

        // Then
        #expect(viewModel.placeholder == .failed(.offline))
    }

    @Test func trackScreenViewWhenShownAgainAfterReviewThenTracksTheTicketOnce() {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)

        // When
        viewModel.trackScreenView()
        viewModel.trackScreenView()

        // Then
        #expect(
            tracker.events(of: TradingEvent.self) == [
                .ticketOpened(.init(symbol: "AAPL", side: .buy, source: .quoteDetail))
            ]
        )
    }

    @Test func visibleIssuesBeforeReviewThenHidesEmptyFields() {
        // Given
        let viewModel = makeViewModel()

        // Then
        #expect(viewModel.visibleIssues.isEmpty)
    }

    @Test func reviewWhenAmountIsMissingThenShowsTheIssueAndShakes() {
        // Given
        let router = TradingRouterSpy()
        let viewModel = makeViewModel(router: router)

        // When
        viewModel.review()

        // Then
        #expect(viewModel.visibleIssues == [.amount: .missing])
        #expect(viewModel.blockedReviewCount == 1)
        #expect(router.reviewedDrafts.isEmpty)
    }

    @Test func refreshEstimateWhenServerPredictsShortCashThenFlagsTheAmount() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.previewResult = .success(.dummy(rejection: .insufficientCash)) }
        let viewModel = makeViewModel(services: services)
        viewModel.setAmountText("200")

        // When
        await viewModel.refreshEstimate()

        // Then
        #expect(viewModel.visibleIssues == [.amount: .insufficientCash])
        #expect(services.previewedDrafts == [.dummy(amount: .shares(200))])
    }

    @Test func refreshEstimateWhenCancelledWhileAskingThenIgnoresTheLateAnswer() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.previewDelay = .seconds(3_600) }
        let viewModel = makeViewModel(services: services)
        viewModel.setAmountText("2")

        // When
        let refreshing = Task { await viewModel.refreshEstimate() }
        while services.previewedDrafts.isEmpty {
            await Task.yield()
        }
        refreshing.cancel()
        await refreshing.value

        // Then
        #expect(viewModel.estimate == .loading(previous: nil))
    }

    @Test func refreshEstimateWhenItFailsThenIsUnavailable() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.previewResult = .failure(.offline) }
        let viewModel = makeViewModel(services: services)
        viewModel.setAmountText("2")

        // When
        await viewModel.refreshEstimate()

        // Then
        #expect(viewModel.estimate == .unavailable)
    }

    @Test(arguments: [
        (OrderRejection.unknownSymbol, TicketField.amount, TicketIssue.notTradable),
        (.invalidAmount, .amount, .belowShareStep),
        (.invalidSchedule, .triggerTime, .outsideSchedule),
    ])
    func visibleIssuesWhenServerPredictsARejectionThenNamesItUnderItsField(
        rejection: OrderRejection,
        field: TicketField,
        issue: TicketIssue
    ) async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.previewResult = .success(.dummy(rejection: rejection)) }
        let viewModel = makeViewModel(services: services)
        viewModel.setAmountText("2")

        // When
        await viewModel.refreshEstimate()

        // Then
        #expect(viewModel.visibleIssues == [field: issue])
        #expect(viewModel.issue(for: field) == issue)
        #expect(viewModel.firstIssueField == field)
    }

    @Test func triggerDateRangeThenRunsFromNowToNinetyDaysAhead() {
        // Given
        let viewModel = makeViewModel()

        // When
        let range = viewModel.triggerDateRange

        // Then
        #expect(range.lowerBound == Date.dummyNow)
        #expect(range.upperBound == Date.dummyNow.addingTimeInterval(90 * 86_400))
    }

    @Test func offersSellAllWhenSellingHeldSharesThenIsTrue() async {
        // Given
        let viewModel = makeViewModel()
        await viewModel.load()

        // When
        viewModel.selectSide(.sell)

        // Then
        #expect(viewModel.offersSellAll)
        #expect(viewModel.offersSideChoice)
        #expect(viewModel.title.key == "trading.ticket.title.sell %@")
    }

    @Test func refreshEstimateWhenDraftIsIncompleteThenIsUnavailable() async {
        // Given
        let services = TradingServicesStub()
        let viewModel = makeViewModel(services: services)

        // When
        await viewModel.refreshEstimate()

        // Then
        #expect(viewModel.estimate == .unavailable)
        #expect(services.previewedDrafts.isEmpty)
    }

    @Test func reviewWhenDraftIsValidThenOpensReview() {
        // Given
        let router = TradingRouterSpy()
        let viewModel = makeViewModel(router: router)
        viewModel.setAmountText("2")

        // When
        viewModel.review()

        // Then
        #expect(router.reviewedDrafts == [.dummy()])
    }

    @Test func sellAllWhenSharesAreHeldThenFillsThemIn() async {
        // Given
        let viewModel = makeViewModel()
        await viewModel.load()

        // When
        viewModel.sellAll()

        // Then
        #expect(viewModel.form.side == .sell)
        #expect(viewModel.form.amountMode == .shares)
        #expect(viewModel.form.amountText == "15")
    }

    @Test func cancelThenClosesTheTicket() {
        // Given
        let router = TradingRouterSpy()
        let viewModel = makeViewModel(router: router)

        // When
        viewModel.cancel()

        // Then
        #expect(router.closeCount == 1)
    }
}

private extension TicketViewModelTests {
    func makeViewModel(
        services: TradingServicesStub = .init(),
        router: TradingRouterSpy = .init(),
        tracker: AnalyticsTrackerSpy = .init()
    ) -> TicketViewModel {
        .init(
            intent: TradeIntent(symbol: "AAPL", side: .buy, source: .quoteDetail),
            quoteProvider: services,
            accountProvider: services,
            positionProvider: services,
            previewer: services,
            router: router,
            tracker: tracker,
            input: DecimalInput(locale: Locale(identifier: "en_US")),
            estimateDelay: .zero,
            now: { Date.dummyNow }
        )
    }
}
