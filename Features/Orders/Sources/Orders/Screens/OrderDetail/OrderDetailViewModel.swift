//
//  OrderDetailViewModel.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Observation

@Observable
final class OrderDetailViewModel {
    enum Cancellation: Equatable {
        case idle
        case confirming
        case working
        case failed(OrdersIssue)
    }

    private(set) var order: Order
    private(set) var cancellation = Cancellation.idle
    private(set) var cancelRequest = 0

    var canCancel: Bool {
        order.status.isOpen
    }

    var isCancelling: Bool {
        cancellation == .working
    }

    var hasCancelFailed: Bool {
        switch cancellation {
        case .failed: true
        case .idle, .confirming, .working: false
        }
    }

    var isConfirmingCancel: Bool {
        cancellation == .confirming
    }

    var statusNote: OrderStatusNote {
        .init(order.status)
    }

    private let canceller: OrderCancelling
    private let router: OrdersRouting
    private let tracker: AnalyticsTracking
    private let onChange: (Order) -> Void

    init(
        order: Order,
        canceller: OrderCancelling,
        router: OrdersRouting,
        tracker: AnalyticsTracking,
        onChange: @escaping (Order) -> Void
    ) {
        self.order = order
        self.canceller = canceller
        self.router = router
        self.tracker = tracker
        self.onChange = onChange
    }

    func requestCancel() {
        guard canCancel else { return }

        cancellation = .confirming
    }

    func dismissCancel() {
        guard cancellation == .confirming else { return }

        cancellation = .idle
    }

    func confirmCancel() {
        guard canCancel, cancellation != .working else { return }

        cancellation = .working
        cancelRequest += 1
    }

    func cancelRequestedOrder() async {
        guard cancellation == .working else { return }

        let result = await cancelOrder()
        guard !Task.isCancelled else { return }

        apply(result)
    }

    func showStock() {
        router.showQuoteDetail(for: order.draft.symbol)
    }
}

private extension OrderDetailViewModel {
    typealias CancelResult = Result<Order, BrokerageError>

    func cancelOrder() async -> CancelResult {
        do {
            return .success(try await canceller.cancel(orderID: order.id))
        } catch {
            return .failure(error)
        }
    }

    func apply(_ result: CancelResult) {
        switch result {
        case .success(let cancelled):
            order = cancelled
            cancellation = .idle
            onChange(cancelled)
            tracker.track(OrdersEvent.cancelled(cancelled.draft))
        case .failure(let error):
            cancellation = .failed(OrdersIssue(error))
        }
    }
}
