//
//  OrdersViewModel.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Observation

@Observable
final class OrdersViewModel {
    private(set) var filter = OrderListFilter.open
    private(set) var lists: [OrderListFilter: OrderList] = [.open: OrderList(), .past: OrderList()]

    var current: OrderList {
        lists[filter] ?? OrderList()
    }

    var placeholder: OrdersPlaceholder? {
        switch (current.phase, current.orders.isEmpty) {
        case (.idle, true), (.loading, true): .loading
        case (.failed(let issue), true): .failed(issue)
        case (.loaded, true): .empty(filter)
        case (_, false): nil
        }
    }

    var days: [OrderDay] {
        current.days(calendar: calendar, now: now())
    }

    var footer: OrdersFooter? {
        current.footer
    }

    private let orderProvider: OrderProviding
    private let router: OrdersRouting
    private let tracker: AnalyticsTracking
    private let calendar: Calendar
    private let now: @Sendable () -> Date
    @ObservationIgnored private var isScreenViewPending = false
    @ObservationIgnored private var loads: [OrderListFilter: OrderListLoads] = [:]

    init(
        orderProvider: OrderProviding,
        router: OrdersRouting,
        tracker: AnalyticsTracking,
        calendar: Calendar,
        now: @escaping @Sendable () -> Date
    ) {
        self.orderProvider = orderProvider
        self.router = router
        self.tracker = tracker
        self.calendar = calendar
        self.now = now
    }

    func trackScreenView() {
        isScreenViewPending = true
        trackPendingScreenView()
    }

    func load() async {
        await loadPage(of: filter, after: nil)
    }

    func loadMore(reaching order: Order) async {
        guard order.id == current.orders.last?.id else { return }

        await loadMore()
    }

    func retryPage() async {
        guard case .failed = footer else { return }

        switch current.hasMore {
        case true:
            await loadMore()
        case false:
            await load()
        }
    }

    func refresh() async {
        async let open: Void = loadPage(of: .open, after: nil)
        async let past: Void = loadPage(of: .past, after: nil)
        _ = await (open, past)
    }

    func selectFilter(_ newFilter: OrderListFilter) {
        filter = newFilter
    }

    func open(_ order: Order) {
        router.showDetail(of: order)
    }

    func replace(_ order: Order) {
        lists[.open]?.orders.removeAll { $0.id == order.id }
        lists[.past]?.orders.removeAll { $0.id == order.id }
        lists[order.status.isOpen ? .open : .past]?.orders.insert(order, at: 0)
    }
}

// MARK: - Private

private extension OrdersViewModel {
    typealias PageResult = Result<Page<Order>, BrokerageError>

    func loadMore() async {
        guard let cursor = current.nextCursor, current.phase != .loading else { return }

        await loadPage(of: filter, after: cursor)
    }

    func loadPage(of filter: OrderListFilter, after cursor: String?) async {
        let load = startLoad(of: filter)
        let result = await fetchPage(of: filter, after: cursor)
        guard !Task.isCancelled else { return abandonLoad(of: filter) }

        finish(load, of: filter, with: result, after: cursor)
    }

    func startLoad(of filter: OrderListFilter) -> Int {
        let load = loads[filter, default: OrderListLoads()].start()
        lists[filter]?.phase = .loading
        return load
    }

    func abandonLoad(of filter: OrderListFilter) {
        loads[filter]?.abandon()
        lists[filter]?.phase = phase(of: filter)
    }

    func fetchPage(of filter: OrderListFilter, after cursor: String?) async -> PageResult {
        do {
            return .success(try await orderProvider.orders(filter, symbol: nil, cursor: cursor))
        } catch {
            return .failure(error)
        }
    }

    func finish(
        _ load: Int,
        of filter: OrderListFilter,
        with result: PageResult,
        after cursor: String?
    ) {
        let isLatest = loads[filter]?.finish(load, settling: settledPhase(of: result)) ?? false
        if isLatest {
            apply(result, to: filter, after: cursor)
        }
        lists[filter]?.phase = phase(of: filter)
        trackPendingScreenView()
    }

    func settledPhase(of result: PageResult) -> OrderList.Phase {
        switch result {
        case .success: .loaded
        case .failure(let error): .failed(OrdersIssue(error))
        }
    }

    func phase(of filter: OrderListFilter) -> OrderList.Phase {
        loads[filter]?.phase ?? .idle
    }

    func apply(_ result: PageResult, to filter: OrderListFilter, after cursor: String?) {
        guard case .success(let page) = result else { return }

        let previous = cursor == nil ? [] : lists[filter]?.orders ?? []
        lists[filter]?.orders = previous + page.elements
        lists[filter]?.nextCursor = page.nextCursor
    }

    func trackPendingScreenView() {
        guard isScreenViewPending, let open = lists[.open], open.phase == .loaded else { return }

        isScreenViewPending = false
        tracker.track(OrdersEvent.viewed(openCount: open.orders.count))
    }
}
