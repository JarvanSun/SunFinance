//
//  TicketViewModel.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Observation

@Observable
final class TicketViewModel {
    private(set) var context: LoadState<TicketContext, TradingIssue> = .idle
    private(set) var form: TicketForm
    private(set) var estimate = EstimateState.unavailable
    private(set) var hasAttemptedReview = false
    private(set) var blockedReviewCount = 0

    var placeholder: TicketPlaceholder? {
        switch context {
        case .idle, .loading:
            .loading
        case .failed(let issue):
            .failed(issue)
        case .loaded:
            nil
        }
    }

    var title: LocalizedStringResource {
        form.side.ticketTitle(for: intent.symbol)
    }

    var draft: OrderDraft? {
        form.draft(symbol: intent.symbol, input: input, now: now())
    }

    var sides: [TradeSide] {
        canSell || form.side == .sell ? TradeSide.allCases : [.buy]
    }

    var offersSideChoice: Bool {
        sides.count > 1
    }

    var offersSellAll: Bool {
        form.side == .sell && canSell
    }

    var triggerDateRange: ClosedRange<Date> {
        form.scheduleRange(from: now())
    }

    var visibleIssues: [TicketField: TicketIssue] {
        let local = form.issues(input: input, now: now()).filter { _, issue in
            hasAttemptedReview || !issue.waitsForReviewAttempt
        }
        guard local.isEmpty, let rejection = settledRejection else { return local }

        return [TicketField(rejection, execution: form.execution): TicketIssue(rejection)]
    }

    var firstIssueField: TicketField? {
        let issues = visibleIssues
        return TicketField.allCases.first { issues[$0] != nil }
    }

    private let intent: TradeIntent
    private let quoteProvider: any QuoteProviding
    private let accountProvider: any AccountProviding
    private let positionProvider: any PositionProviding
    private let previewer: any OrderPreviewing
    private let router: any TradingRouting
    private let tracker: any AnalyticsTracking
    private let input: DecimalInput
    private let estimateDelay: Duration
    private let now: @Sendable () -> Date
    @ObservationIgnored private var hasTrackedScreenView = false

    init(
        intent: TradeIntent,
        quoteProvider: some QuoteProviding,
        accountProvider: some AccountProviding,
        positionProvider: some PositionProviding,
        previewer: some OrderPreviewing,
        router: some TradingRouting,
        tracker: some AnalyticsTracking,
        input: DecimalInput,
        estimateDelay: Duration,
        now: @escaping @Sendable () -> Date
    ) {
        self.intent = intent
        self.quoteProvider = quoteProvider
        self.accountProvider = accountProvider
        self.positionProvider = positionProvider
        self.previewer = previewer
        self.router = router
        self.tracker = tracker
        self.input = input
        self.estimateDelay = estimateDelay
        self.now = now
        form = TicketForm(side: intent.side, triggerDate: Self.defaultTriggerDate(after: now()))
    }

    func trackScreenView() {
        guard !hasTrackedScreenView else { return }

        hasTrackedScreenView = true
        tracker.track(TradingEvent.ticketOpened(intent))
    }

    func load() async {
        context = context.value.map(LoadState.loaded) ?? .loading
        let result = await fetchContext()
        guard !Task.isCancelled else { return }

        context = result
    }

    func refreshEstimate() async {
        guard let draft else {
            estimate = .unavailable
            return
        }

        estimate = .loading(previous: estimate.preview)
        try? await Task.sleep(for: estimateDelay)
        guard !Task.isCancelled else { return }

        let result = await fetchEstimate(of: draft)
        guard !Task.isCancelled else { return }

        apply(result)
    }

    func selectSide(_ side: TradeSide) {
        form.side = side
    }

    func selectAmountMode(_ mode: AmountMode) {
        form.amountMode = mode
    }

    func setAmountText(_ text: String) {
        form.amountText = text
    }

    func selectExecution(_ execution: ExecutionKind) {
        form.execution = execution
    }

    func setLimitText(_ text: String) {
        form.limitText = text
    }

    func selectTrigger(_ trigger: TriggerKind) {
        form.trigger = trigger
    }

    func setTriggerPriceText(_ text: String) {
        form.triggerPriceText = text
    }

    func setTriggerDate(_ date: Date) {
        form.triggerDate = date
    }

    func selectValidity(_ validity: OrderValidity) {
        form.validity = validity
    }

    func sellAll() {
        guard let held = context.value?.heldShares, held > 0 else { return }

        form.side = .sell
        form.amountMode = .shares
        form.amountText = input.text(for: held)
    }

    func review() {
        hasAttemptedReview = true
        guard let draft, visibleIssues.isEmpty else {
            blockedReviewCount += 1
            return
        }

        router.showReview(of: draft)
    }

    func cancel() {
        router.close()
    }

    func issue(for field: TicketField) -> TicketIssue? {
        visibleIssues[field]
    }
}

// MARK: - Private

private extension TicketViewModel {
    typealias EstimateResult = Result<OrderPreview, BrokerageError>

    var canSell: Bool {
        (context.value?.heldShares ?? 0) > 0
    }

    var settledRejection: OrderRejection? {
        switch estimate {
        case .ready(let preview):
            preview.rejection
        case .unavailable, .loading:
            nil
        }
    }

    static func defaultTriggerDate(after date: Date) -> Date {
        let quarterHour: TimeInterval = 15 * 60
        let inAnHour = date.addingTimeInterval(4 * quarterHour)
        return Date(
            timeIntervalSinceReferenceDate: (inAnHour.timeIntervalSinceReferenceDate / quarterHour)
                .rounded(.up) * quarterHour
        )
    }

    func fetchContext() async -> LoadState<TicketContext, TradingIssue> {
        async let quotes = quoteProvider.quotes(for: [intent.symbol])
        async let account = accountProvider.account()
        async let portfolio = positionProvider.portfolio()
        do {
            guard let quote = try await quotes.first else { return .failed(.serviceUnavailable) }

            let held = try await portfolio.position(of: intent.symbol)?.quantity ?? 0
            let context = TicketContext(
                quote: quote,
                buyingPower: try await account.buyingPower,
                heldShares: held
            )
            return .loaded(context)
        } catch let error as MarketDataError {
            return .failed(TradingIssue(error))
        } catch let error as BrokerageError {
            return .failed(TradingIssue(error))
        } catch {
            return .failed(.serviceUnavailable)
        }
    }

    func fetchEstimate(of draft: OrderDraft) async -> EstimateResult {
        do {
            return .success(try await previewer.preview(draft))
        } catch {
            return .failure(error)
        }
    }

    func apply(_ result: EstimateResult) {
        switch result {
        case .success(let preview):
            estimate = .ready(preview)
        case .failure:
            estimate = .unavailable
        }
    }
}
