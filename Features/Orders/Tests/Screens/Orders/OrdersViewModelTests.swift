//
//  OrdersViewModelTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Orders

struct OrdersViewModelTests {
    @Test func loadThenShowsOpenOrdersByDay() async {
        // Given
        let stub = OrdersStub()
        stub.update {
            $0.pages[.open] = [nil: Page(elements: [.dummy("1"), .dummy("2")], nextCursor: nil)]
        }
        let viewModel = makeViewModel(stub: stub)

        // When
        await viewModel.load()

        // Then
        #expect(viewModel.current.orders.map(\.id) == ["1", "2"])
        #expect(viewModel.days.map(\.heading) == [.today])
        #expect(viewModel.placeholder == nil)
        #expect(viewModel.footer == nil)
    }

    @Test func trackScreenViewWhenShownBeforeLoadingThenTracksOnceTheOpenOrdersAreKnown() async {
        // Given
        let stub = OrdersStub()
        stub.update {
            $0.pages[.open] = [nil: Page(elements: [.dummy("1"), .dummy("2")], nextCursor: nil)]
        }
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(stub: stub, tracker: tracker)

        // When
        viewModel.trackScreenView()
        let eventsBeforeLoading = tracker.events(of: OrdersEvent.self)
        await viewModel.load()
        await viewModel.load()

        // Then
        #expect(eventsBeforeLoading.isEmpty)
        #expect(tracker.events(of: OrdersEvent.self) == [.viewed(openCount: 2)])
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
            tracker.events(of: OrdersEvent.self) == [.viewed(openCount: 0), .viewed(openCount: 0)]
        )
    }

    @Test func placeholderThenFollowsTheCurrentList() async {
        // Given
        let viewModel = makeViewModel()
        let beforeLoading = viewModel.placeholder

        // When
        await viewModel.load()

        // Then
        #expect(beforeLoading == .loading)
        #expect(viewModel.placeholder == .empty(.open))
    }

    @Test func loadMoreWhenTheLastOrderComesOnScreenThenAppendsTheNextPage() async {
        // Given
        let stub = OrdersStub()
        stub.update {
            $0.pages[.past] = [
                nil: Page(elements: [.dummy("1", status: .filled)], nextCursor: "1"),
                "1": Page(elements: [.dummy("2", status: .expired)], nextCursor: nil),
            ]
        }
        let viewModel = makeViewModel(stub: stub)
        viewModel.selectFilter(.past)
        await viewModel.load()
        let footerBefore = viewModel.footer

        // When
        await viewModel.loadMore(reaching: .dummy("1", status: .filled))

        // Then
        #expect(footerBefore == .loadingMore)
        #expect(viewModel.current.orders.map(\.id) == ["1", "2"])
        #expect(!viewModel.current.hasMore)
        #expect(viewModel.footer == nil)
    }

    @Test func loadMoreWhenAnEarlierOrderComesOnScreenThenWaits() async {
        // Given
        let stub = OrdersStub()
        stub.update {
            $0.pages[.open] = [
                nil: Page(elements: [.dummy("1"), .dummy("2")], nextCursor: "2")
            ]
        }
        let viewModel = makeViewModel(stub: stub)
        await viewModel.load()

        // When
        await viewModel.loadMore(reaching: .dummy("1"))

        // Then
        #expect(stub.requests == 1)
    }

    @Test func loadMoreWhenThePageFailsThenOffersARetryThatLoadsIt() async {
        // Given
        let stub = OrdersStub()
        stub.update {
            $0.pages[.open] = [
                nil: Page(elements: [.dummy("1")], nextCursor: "1"),
                "1": Page(elements: [.dummy("2")], nextCursor: nil),
            ]
            $0.failingCursor = "1"
        }
        let viewModel = makeViewModel(stub: stub)
        await viewModel.load()
        await viewModel.loadMore(reaching: .dummy("1"))
        let footerAfterFailure = viewModel.footer

        // When
        stub.update { $0.failingCursor = nil }
        await viewModel.retryPage()

        // Then
        #expect(footerAfterFailure == .failed(.offline))
        #expect(viewModel.current.orders.map(\.id) == ["1", "2"])
        #expect(viewModel.footer == nil)
    }

    @Test func retryPageWhenNothingFailedThenDoesNothing() async {
        // Given
        let stub = OrdersStub()
        let viewModel = makeViewModel(stub: stub)

        // When
        await viewModel.retryPage()

        // Then
        #expect(stub.requests == 0)
    }

    @Test func loadWhenCancelledWhileLoadingThenRestoresThePhase() async {
        // Given
        let stub = OrdersStub()
        stub.update { $0.delay = .seconds(3_600) }
        let viewModel = makeViewModel(stub: stub)

        // When
        let loading = Task { await viewModel.load() }
        while stub.requests == 0 {
            await Task.yield()
        }
        loading.cancel()
        await loading.value

        // Then
        #expect(viewModel.current.phase == .idle)
    }

    @Test func loadWhenARefreshFinishedMeanwhileAndTheLoadIsCancelledThenLoadMoreStillWorks()
        async
    {
        // Given
        let stub = OrdersStub()
        stub.update {
            $0.pages[.open] = [
                nil: Page(elements: [.dummy("1")], nextCursor: "1"),
                "1": Page(elements: [.dummy("2")], nextCursor: nil),
            ]
            $0.delays = [.seconds(3_600)]
        }
        let viewModel = makeViewModel(stub: stub)
        let loading = Task { await viewModel.load() }
        while stub.requests == 0 {
            await Task.yield()
        }

        // When
        await viewModel.refresh()
        let phaseWhileTheLoadRuns = viewModel.current.phase
        loading.cancel()
        await loading.value
        await viewModel.loadMore(reaching: .dummy("1"))

        // Then
        #expect(phaseWhileTheLoadRuns == .loading)
        #expect(viewModel.current.orders.map(\.id) == ["1", "2"])
        #expect(viewModel.current.phase == .loaded)
    }

    @Test func refreshWhenTheEarlierLoadFinishesFirstAndTheRefreshIsCancelledThenSettles() async {
        // Given
        let stub = OrdersStub()
        stub.update {
            $0.pages[.open] = [nil: Page(elements: [.dummy("1")], nextCursor: "1")]
            $0.delays = [.milliseconds(20), .seconds(3_600)]
        }
        let viewModel = makeViewModel(stub: stub)
        let loading = Task { await viewModel.load() }
        while stub.requests == 0 {
            await Task.yield()
        }
        let refreshing = Task { await viewModel.load() }
        while stub.requests < 2 {
            await Task.yield()
        }

        // When
        await loading.value
        refreshing.cancel()
        await refreshing.value

        // Then
        #expect(viewModel.current.phase == .loaded)
        #expect(viewModel.current.orders.map(\.id) == ["1"])
        #expect(viewModel.footer == .loadingMore)
    }

    @Test func loadWhenANewerLoadAlreadyAnsweredThenIgnoresTheOlderAnswer() async {
        // Given
        let stub = OrdersStub()
        stub.update {
            $0.pages[.open] = [nil: Page(elements: [.dummy("new")], nextCursor: nil)]
            $0.delays = [.milliseconds(20), .zero]
        }
        let viewModel = makeViewModel(stub: stub)
        let older = Task { await viewModel.load() }
        while stub.requests == 0 {
            await Task.yield()
        }

        // When
        await viewModel.load()
        stub.update { $0.pages[.open] = [nil: Page(elements: [.dummy("old")], nextCursor: nil)] }
        await older.value

        // Then
        #expect(viewModel.current.orders.map(\.id) == ["new"])
        #expect(viewModel.current.phase == .loaded)
    }

    @Test func loadWhenOfflineThenListFails() async {
        // Given
        let stub = OrdersStub()
        stub.update { $0.failure = .offline }
        let viewModel = makeViewModel(stub: stub)

        // When
        await viewModel.load()

        // Then
        #expect(viewModel.current.phase == .failed(.offline))
        #expect(viewModel.placeholder == .failed(.offline))
    }

    @Test func refreshThenLoadsBothLists() async {
        // Given
        let stub = OrdersStub()
        stub.update {
            $0.pages[.open] = [nil: Page(elements: [.dummy("1")], nextCursor: nil)]
            $0.pages[.past] = [nil: Page(elements: [.dummy("2", status: .filled)], nextCursor: nil)]
        }
        let viewModel = makeViewModel(stub: stub)

        // When
        await viewModel.refresh()

        // Then
        #expect(viewModel.lists[.open]?.orders.map(\.id) == ["1"])
        #expect(viewModel.lists[.past]?.orders.map(\.id) == ["2"])
    }

    @Test func replaceWhenCancelledThenMovesFromOpenToPast() async {
        // Given
        let stub = OrdersStub()
        stub.update { $0.pages[.open] = [nil: Page(elements: [.dummy("1")], nextCursor: nil)] }
        let viewModel = makeViewModel(stub: stub)
        await viewModel.load()

        // When
        viewModel.replace(.dummy("1", status: .cancelled))

        // Then
        #expect(viewModel.lists[.open]?.orders.isEmpty == true)
        #expect(viewModel.lists[.past]?.orders.map(\.id) == ["1"])
    }

    @Test func openThenShowsTheDetail() {
        // Given
        let router = OrdersRouterSpy()
        let viewModel = makeViewModel(router: router)

        // When
        viewModel.open(.dummy("7"))

        // Then
        #expect(router.details.map(\.id) == ["7"])
    }
}

private extension OrdersViewModelTests {
    func makeViewModel(
        stub: OrdersStub = .init(),
        router: OrdersRouterSpy = .init(),
        tracker: AnalyticsTrackerSpy = .init()
    ) -> OrdersViewModel {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return .init(
            orderProvider: stub,
            router: router,
            tracker: tracker,
            calendar: calendar,
            now: { Date(timeIntervalSince1970: 3_600) }
        )
    }
}
