//
//  PortfolioViewModel.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Observation

@Observable
final class PortfolioViewModel {
    private(set) var snapshot: LoadState<PortfolioSnapshot, PortfolioIssue> = .idle
    private(set) var history = RangedHistory<HistoryRange, PortfolioHistory, PortfolioIssue>(
        range: .month
    )
    private(set) var freshness = PortfolioFreshness.live
    private(set) var scrubbedMoment: Date?
    private(set) var selectedSymbol: TickerSymbol?

    let ranges: [HistoryRange] = [.week, .month, .threeMonths, .year, .fiveYears]

    var range: HistoryRange {
        history.range
    }

    var isLive: Bool {
        switch freshness {
        case .live:
            true
        case .stale:
            false
        }
    }

    var placeholder: PortfolioPlaceholder? {
        switch snapshot {
        case .idle, .loading:
            .loading
        case .failed(let issue):
            .failed(issue)
        case .loaded:
            nil
        }
    }

    var positionsPlaceholder: PortfolioPlaceholder? {
        switch snapshot.value?.hasOpenPositions {
        case .some(false):
            .empty
        case .some(true), nil:
            nil
        }
    }

    var openPositions: [Position] {
        snapshot.value?.portfolio.open ?? []
    }

    var closedPositions: [Position] {
        snapshot.value?.portfolio.closed ?? []
    }

    var hasClosedPositions: Bool {
        !closedPositions.isEmpty
    }

    private let accountProvider: any AccountProviding
    private let positionProvider: any PositionProviding
    private let historyProvider: any PortfolioHistoryProviding
    private let router: any PortfolioRouting
    private let tracker: any AnalyticsTracking
    private let refreshInterval: Duration
    @ObservationIgnored private var isScreenViewPending = false

    init(
        accountProvider: some AccountProviding,
        positionProvider: some PositionProviding,
        historyProvider: some PortfolioHistoryProviding,
        router: some PortfolioRouting,
        tracker: some AnalyticsTracking,
        refreshInterval: Duration
    ) {
        self.accountProvider = accountProvider
        self.positionProvider = positionProvider
        self.historyProvider = historyProvider
        self.router = router
        self.tracker = tracker
        self.refreshInterval = refreshInterval
    }

    func trackScreenView() {
        isScreenViewPending = true
        trackPendingScreenView()
    }

    func load() async {
        snapshot = snapshot.reloading
        let result = await fetchSnapshot()
        guard !Task.isCancelled else { return }

        apply(result)
    }

    func loadHistory() async {
        let requested = range
        history.startLoading()
        let result = await fetchHistory(of: requested)
        guard !Task.isCancelled else { return }

        history.settle(with: result, for: requested)
    }

    func refresh() async {
        async let snapshot: Void = load()
        async let history: Void = loadHistory()
        _ = await (snapshot, history)
    }

    func keepFresh() async {
        for await update in positionProvider.portfolioUpdates(every: refreshInterval) {
            let result = await refreshedSnapshot(from: update)
            guard !Task.isCancelled else { return }

            apply(result)
        }
    }

    func selectRange(_ newRange: HistoryRange) {
        guard newRange != range else { return }

        history.select(newRange)
        scrubbedMoment = nil
        tracker.track(PortfolioEvent.rangeChanged(newRange))
    }

    func scrub(to moment: Date?) {
        scrubbedMoment = moment
    }

    func selectSlice(_ symbol: TickerSymbol?) {
        selectedSymbol = symbol == selectedSymbol ? nil : symbol
    }

    func openPosition(_ symbol: TickerSymbol) {
        tracker.track(PortfolioEvent.positionOpened(symbol))
        router.showQuoteDetail(for: symbol)
    }

    func perform(_ action: PositionAction, on symbol: TickerSymbol) {
        router.showOrderTicket(
            for: TradeIntent(symbol: symbol, side: action.side, source: .position)
        )
    }

    func header(of snapshot: PortfolioSnapshot) -> PortfolioHeader {
        switch scrubbedPoint {
        case .some((let point, let first)):
            PortfolioHeader(
                value: point.value,
                change: PortfolioChange(from: first.value, to: point.value),
                moment: .scrubbed(point.date)
            )
        case nil:
            PortfolioHeader(
                value: snapshot.account.total,
                change: rangeChange(to: snapshot.account.total),
                moment: .range(range)
            )
        }
    }
}

// MARK: - Private

private extension PortfolioViewModel {
    typealias SnapshotResult = Result<PortfolioSnapshot, BrokerageError>

    var scrubbedPoint: (PortfolioValuePoint, PortfolioValuePoint)? {
        guard
            let scrubbedMoment,
            let points = history.selected?.points,
            let start = points.first,
            let point = points.last(where: { $0.date <= scrubbedMoment })
        else { return nil }

        return (point, start)
    }

    func rangeChange(to value: Money) -> PortfolioChange {
        switch history.selected?.points.first {
        case .some(let start):
            PortfolioChange(from: start.value, to: value)
        case nil:
            .pending
        }
    }

    func fetchSnapshot() async -> SnapshotResult {
        async let account = accountProvider.account()
        async let portfolio = positionProvider.portfolio()
        do {
            return .success(
                PortfolioSnapshot(account: try await account, portfolio: try await portfolio)
            )
        } catch let error as BrokerageError {
            return .failure(error)
        } catch {
            return .failure(.cancelled)
        }
    }

    func refreshedSnapshot(from update: Result<Portfolio, BrokerageError>) async -> SnapshotResult {
        switch update {
        case .success(let portfolio):
            await fetchSnapshot(with: portfolio)
        case .failure(let error):
            .failure(error)
        }
    }

    func fetchSnapshot(with portfolio: Portfolio) async -> SnapshotResult {
        do {
            return .success(
                PortfolioSnapshot(
                    account: try await accountProvider.account(),
                    portfolio: portfolio
                )
            )
        } catch {
            return .failure(error)
        }
    }

    func apply(_ result: SnapshotResult) {
        switch result {
        case .success(let fetchedSnapshot):
            snapshot = .loaded(fetchedSnapshot)
            freshness = .live
            trackPendingScreenView()
        case .failure(let error):
            let issue = PortfolioIssue(error)
            snapshot = snapshot.settled(with: .failed(issue))
            freshness = .stale(issue)
        }
    }

    func fetchHistory(of range: HistoryRange) async -> LoadState<PortfolioHistory, PortfolioIssue> {
        do {
            return .loaded(try await historyProvider.portfolioHistory(range: range))
        } catch {
            return .failed(PortfolioIssue(error))
        }
    }

    func trackPendingScreenView() {
        guard isScreenViewPending, let count = snapshot.value?.portfolio.open.count else { return }

        isScreenViewPending = false
        tracker.track(PortfolioEvent.viewed(positionCount: count))
    }
}
