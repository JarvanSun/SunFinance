//
//  OrderDetailViewModelTests.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Orders

struct OrderDetailViewModelTests {
    @Test func confirmCancelWhenItSucceedsThenUpdatesReportsAndTracks() async {
        // Given
        let tracker = AnalyticsTrackerSpy()
        var reported: [Order] = []
        let viewModel = OrderDetailViewModel(
            order: .make("1"),
            canceller: OrdersStub(),
            router: OrdersRouterSpy(),
            tracker: tracker
        ) { reported.append($0) }
        viewModel.requestCancel()

        // When
        viewModel.confirmCancel()
        let requested = viewModel.cancelRequest
        await viewModel.cancelRequestedOrder()

        // Then
        #expect(requested == 1)
        #expect(viewModel.order.status == .cancelled)
        #expect(!viewModel.canCancel)
        #expect(viewModel.statusNote == .none)
        #expect(reported.map(\.status) == [.cancelled])
        #expect(tracker.events(of: OrdersEvent.self) == [.cancelled(Order.make("1").draft)])
    }

    @Test func confirmCancelThenShowsWorkingUntilTheServerAnswers() {
        // Given
        let viewModel = makeViewModel()
        viewModel.requestCancel()

        // When
        viewModel.confirmCancel()
        viewModel.dismissCancel()

        // Then
        #expect(viewModel.isCancelling)
        #expect(!viewModel.isConfirmingCancel)
    }

    @Test func confirmCancelWhenItFailsThenKeepsTheOrderOpen() async {
        // Given
        let stub = OrdersStub()
        stub.update { $0.cancelResult = .failure(.offline) }
        let viewModel = makeViewModel(stub: stub)

        // When
        viewModel.confirmCancel()
        await viewModel.cancelRequestedOrder()

        // Then
        #expect(viewModel.cancellation == .failed(.offline))
        #expect(viewModel.hasCancelFailed)
        #expect(viewModel.canCancel)
    }

    @Test func cancelRequestedOrderWhenNothingWasConfirmedThenCancelsNothing() async {
        // Given
        let viewModel = makeViewModel()

        // When
        await viewModel.cancelRequestedOrder()

        // Then
        #expect(viewModel.order.status == .waitingForPrice)
        #expect(viewModel.cancellation == .idle)
    }

    @Test func requestCancelWhenOrderIsPastThenAsksNothing() {
        // Given
        let viewModel = makeViewModel(order: .make("1", status: .filled))

        // When
        viewModel.requestCancel()
        viewModel.confirmCancel()

        // Then
        #expect(viewModel.cancellation == .idle)
        #expect(viewModel.cancelRequest == 0)
    }

    @Test func dismissCancelThenKeepsTheOrder() {
        // Given
        let viewModel = makeViewModel()
        viewModel.requestCancel()

        // When
        viewModel.dismissCancel()

        // Then
        #expect(viewModel.cancellation == .idle)
    }

    @Test func showStockThenOpensQuoteDetail() {
        // Given
        let router = OrdersRouterSpy()
        let viewModel = makeViewModel(router: router)

        // When
        viewModel.showStock()

        // Then
        #expect(router.stocks == ["SAP"])
    }
}

private extension OrderDetailViewModelTests {
    func makeViewModel(
        order: Order = .make("1"),
        stub: OrdersStub = OrdersStub(),
        router: OrdersRouterSpy = OrdersRouterSpy()
    ) -> OrderDetailViewModel {
        OrderDetailViewModel(
            order: order,
            canceller: stub,
            router: router,
            tracker: AnalyticsTrackerSpy()
        ) { _ in }
    }
}
