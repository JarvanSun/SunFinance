//
//  ReviewViewModel.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Observation

@Observable
final class ReviewViewModel {
    private(set) var preview: LoadState<OrderPreview, TradingIssue> = .idle
    private(set) var placement = PlacementState.ready
    private(set) var placementRequest = 0

    let draft: OrderDraft

    var canConfirm: Bool {
        switch (preview, placement) {
        case (.loaded(let preview), .ready), (.loaded(let preview), .failed):
            preview.rejection == nil
        case (_, .ready), (_, .placing), (_, .placed), (_, .failed): false
        }
    }

    var isSliderEnabled: Bool {
        switch placement {
        case .ready, .failed: canConfirm
        case .placing, .placed: true
        }
    }

    var predictedRejection: OrderRejection? {
        preview.value?.rejection
    }

    var currency: CurrencyCode {
        preview.value?.price.currency ?? .eur
    }

    var outcome: OrderOutcome? {
        switch placement {
        case .placed(let order): OrderOutcome(order)
        case .ready, .placing, .failed: nil
        }
    }

    var canGoBack: Bool {
        switch placement {
        case .ready, .failed: true
        case .placing: false
        case .placed: outcome?.allowsEditing == true
        }
    }

    private let previewer: OrderPreviewing
    private let placer: OrderPlacing
    private let keys: PlacementKeys
    private let router: TradingRouting
    private let tracker: AnalyticsTracking
    private let idempotencyKey: IdempotencyKey
    @ObservationIgnored private var placing: Task<PlacementResult, Never>?

    init(
        draft: OrderDraft,
        previewer: OrderPreviewing,
        placer: OrderPlacing,
        keys: PlacementKeys,
        router: TradingRouting,
        tracker: AnalyticsTracking
    ) {
        self.draft = draft
        self.previewer = previewer
        self.placer = placer
        self.keys = keys
        self.router = router
        self.tracker = tracker
        idempotencyKey = keys.key(for: draft)
    }

    func loadPreview() async {
        preview = preview.value.map(LoadState.loaded) ?? .loading
        let result = await fetchPreview()
        guard !Task.isCancelled else { return }

        apply(result)
    }

    func confirm() {
        guard canConfirm else { return }

        placement = .placing
        placementRequest += 1
    }

    func placeRequestedOrder() async {
        guard placement == .placing else { return }

        let result = await placeOutlivingTheScreen()
        apply(result)
    }

    func editOrder() {
        router.returnToTicket()
    }

    func finish() {
        router.close()
    }
}

// MARK: - Private

private extension ReviewViewModel {
    typealias PreviewResult = Result<OrderPreview, BrokerageError>
    typealias PlacementResult = Result<Order, BrokerageError>

    func fetchPreview() async -> PreviewResult {
        do {
            return .success(try await previewer.preview(draft))
        } catch {
            return .failure(error)
        }
    }

    func apply(_ result: PreviewResult) {
        switch result {
        case .success(let fetchedPreview):
            preview = .loaded(fetchedPreview)
            tracker.track(TradingEvent.orderReviewed(draft))
        case .failure(let error):
            let issue = TradingIssue(error)
            preview = .failed(issue)
            tracker.track(TradingEvent.orderFailed(reason: issue.analyticsReason))
        }
    }

    func placeOutlivingTheScreen() async -> PlacementResult {
        let request = placing ?? Task { await place() }
        placing = request
        let result = await request.value
        placing = nil
        return result
    }

    func place() async -> PlacementResult {
        do {
            return .success(try await placer.place(draft, idempotencyKey: idempotencyKey))
        } catch {
            return .failure(error)
        }
    }

    func apply(_ result: PlacementResult) {
        guard placement == .placing else { return }

        switch result {
        case .success(let order):
            keys.spend(idempotencyKey)
            placement = .placed(order)
            tracker.track(TradingEvent.orderPlaced(order))
        case .failure(let error):
            let issue = TradingIssue(error)
            placement = .failed(issue)
            tracker.track(TradingEvent.orderFailed(reason: issue.analyticsReason))
        }
    }
}
