//
//  ReviewViewModelTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct ReviewViewModelTests {
    @Test func loadPreviewWhenItSucceedsThenAllowsConfirmingAndTracks() async {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)

        // When
        await viewModel.loadPreview()

        // Then
        #expect(viewModel.canConfirm)
        #expect(viewModel.isSliderEnabled)
        #expect(viewModel.currency == .usd)
        #expect(tracker.events(of: TradingEvent.self) == [.orderReviewed(.init())])
    }

    @Test func loadPreviewWhenServerPredictsARejectionThenBlocksConfirming() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.previewResult = .success(.init(rejection: .insufficientShares)) }
        let viewModel = makeViewModel(services: services)

        // When
        await viewModel.loadPreview()

        // Then
        #expect(!viewModel.canConfirm)
        #expect(!viewModel.isSliderEnabled)
        #expect(viewModel.predictedRejection == .insufficientShares)
    }

    @Test func loadPreviewWhenOfflineThenFailsAndTracksTheReason() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.previewResult = .failure(.offline) }
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(services: services, tracker: tracker)

        // When
        await viewModel.loadPreview()

        // Then
        #expect(viewModel.preview == .failed(.offline))
        #expect(tracker.events(of: TradingEvent.self) == [.orderFailed(reason: "offline")])
    }

    @Test func loadPreviewWhenCancelledWhileAskingThenIgnoresTheLateAnswer() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.previewDelay = .seconds(3_600) }
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(services: services, tracker: tracker)

        // When
        let loading = Task { await viewModel.loadPreview() }
        while services.previewedDrafts.isEmpty {
            await Task.yield()
        }
        loading.cancel()
        await loading.value

        // Then
        #expect(viewModel.preview == .loading)
        #expect(tracker.events(of: TradingEvent.self).isEmpty)
    }

    @Test func confirmWhenPlacedThenShowsOutcomeAndTracks() async {
        // Given
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(tracker: tracker)
        await viewModel.loadPreview()

        // When
        viewModel.confirm()
        await viewModel.placeRequestedOrder()

        // Then
        #expect(viewModel.outcome == .filled(Order(status: .filled).fill!))
        #expect(!viewModel.canGoBack)
        #expect(tracker.events(of: TradingEvent.self).last == .orderPlaced(.init(status: .filled)))
    }

    @Test func confirmThenPlacesOnlyOncePerRequest() async {
        // Given
        let services = TradingServicesStub()
        let viewModel = makeViewModel(services: services)
        await viewModel.loadPreview()

        // When
        viewModel.confirm()
        let placingRequest = viewModel.placementRequest
        let placingPhase = viewModel.placement
        await viewModel.placeRequestedOrder()
        await viewModel.placeRequestedOrder()

        // Then
        #expect(placingRequest == 1)
        #expect(placingPhase == .placing)
        #expect(services.placedKeys.count == 1)
    }

    @Test func placeRequestedOrderWhenTheScreenIsCancelledWhilePlacingThenSettlesWithTheAnswer()
        async
    {
        // Given
        let services = TradingServicesStub()
        services.update { $0.placeDelay = .milliseconds(20) }
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(services: services, tracker: tracker)
        await viewModel.loadPreview()
        viewModel.confirm()

        // When
        let placing = Task { await viewModel.placeRequestedOrder() }
        while services.placedKeys.isEmpty {
            await Task.yield()
        }
        placing.cancel()
        await placing.value

        // Then
        #expect(viewModel.outcome == .filled(Order(status: .filled).fill!))
        #expect(tracker.events(of: TradingEvent.self).last == .orderPlaced(.init(status: .filled)))
    }

    @Test func placeRequestedOrderWhenAskedAgainWhilePlacingThenSendsTheOrderOnce() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.placeDelay = .milliseconds(20) }
        let tracker = AnalyticsTrackerSpy()
        let viewModel = makeViewModel(services: services, tracker: tracker)
        await viewModel.loadPreview()
        viewModel.confirm()

        // When
        let first = Task { await viewModel.placeRequestedOrder() }
        while services.placedKeys.isEmpty {
            await Task.yield()
        }
        await viewModel.placeRequestedOrder()
        await first.value

        // Then
        let placedEvents = tracker.events(of: TradingEvent.self).filter {
            $0 == .orderPlaced(.init(status: .filled))
        }
        #expect(services.placedKeys.count == 1)
        #expect(placedEvents.count == 1)
        #expect(viewModel.outcome == .filled(Order(status: .filled).fill!))
    }

    @Test func confirmWhenRetriedAfterAFailureThenReusesTheKey() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.placeResults = [.failure(.offline), .success(.waitingForOpen)] }
        let viewModel = makeViewModel(services: services)
        await viewModel.loadPreview()

        // When
        viewModel.confirm()
        await viewModel.placeRequestedOrder()
        let placementAfterFailure = viewModel.placement
        viewModel.confirm()
        await viewModel.placeRequestedOrder()

        // Then
        #expect(placementAfterFailure == .failed(.offline))
        #expect(viewModel.outcome == .waitingForOpen)
        #expect(services.placedKeys.count == 2)
        #expect(Set(services.placedKeys).count == 1)
    }

    @Test func canGoBackWhenPlacingFailedThenLetsTheUserLeave() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.placeResults = [.failure(.server(statusCode: 503))] }
        let viewModel = makeViewModel(services: services)
        await viewModel.loadPreview()

        // When
        viewModel.confirm()
        await viewModel.placeRequestedOrder()

        // Then
        #expect(viewModel.placement == .failed(.serviceUnavailable))
        #expect(viewModel.canGoBack)
    }

    @Test func confirmWhenTheSameDraftIsReviewedAgainAfterAFailureThenReusesTheKey() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.placeResults = [.failure(.offline), .success(.filled)] }
        let keys = PlacementKeys()
        let firstReview = makeViewModel(services: services, keys: keys)
        await firstReview.loadPreview()
        firstReview.confirm()
        await firstReview.placeRequestedOrder()

        // When
        let secondReview = makeViewModel(services: services, keys: keys)
        await secondReview.loadPreview()
        secondReview.confirm()
        await secondReview.placeRequestedOrder()

        // Then
        #expect(services.placedKeys.count == 2)
        #expect(Set(services.placedKeys).count == 1)
    }

    @Test func confirmWhenAnEditedDraftIsReviewedThenUsesANewKey() async {
        // Given
        let services = TradingServicesStub()
        services.update { $0.placeResults = [.failure(.offline), .success(.filled)] }
        let keys = PlacementKeys()
        let firstReview = makeViewModel(services: services, keys: keys)
        await firstReview.loadPreview()
        firstReview.confirm()
        await firstReview.placeRequestedOrder()

        // When
        let editedReview = makeViewModel(
            draft: .init(amount: .shares(3)),
            services: services,
            keys: keys
        )
        await editedReview.loadPreview()
        editedReview.confirm()
        await editedReview.placeRequestedOrder()

        // Then
        #expect(Set(services.placedKeys).count == 2)
    }

    @Test func confirmWhenTheServerAnsweredThenTheNextReviewUsesANewKey() async {
        // Given
        let services = TradingServicesStub()
        services.update {
            $0.placeResults = [.success(.rejected(.insufficientCash)), .success(.filled)]
        }
        let keys = PlacementKeys()
        let firstReview = makeViewModel(services: services, keys: keys)
        await firstReview.loadPreview()
        firstReview.confirm()
        await firstReview.placeRequestedOrder()

        // When
        let secondReview = makeViewModel(services: services, keys: keys)
        await secondReview.loadPreview()
        secondReview.confirm()
        await secondReview.placeRequestedOrder()

        // Then
        #expect(firstReview.canGoBack)
        #expect(Set(services.placedKeys).count == 2)
    }

    @Test func confirmWhenPreviewIsMissingThenPlacesNothing() async {
        // Given
        let services = TradingServicesStub()
        let viewModel = makeViewModel(services: services)

        // When
        viewModel.confirm()
        await viewModel.placeRequestedOrder()

        // Then
        #expect(viewModel.placementRequest == 0)
        #expect(services.placedKeys.isEmpty)
    }

    @Test func finishThenCloses() {
        // Given
        let router = TradingRouterSpy()
        let viewModel = makeViewModel(router: router)

        // When
        viewModel.finish()

        // Then
        #expect(router.closeCount == 1)
    }

    @Test func editOrderThenReturnsToTheTicket() {
        // Given
        let router = TradingRouterSpy()
        let viewModel = makeViewModel(router: router)

        // When
        viewModel.editOrder()

        // Then
        #expect(router.returnCount == 1)
    }
}

private extension ReviewViewModelTests {
    func makeViewModel(
        draft: OrderDraft = .init(),
        services: TradingServicesStub = TradingServicesStub(),
        keys: PlacementKeys = PlacementKeys(),
        router: TradingRouterSpy = TradingRouterSpy(),
        tracker: AnalyticsTrackerSpy = AnalyticsTrackerSpy()
    ) -> ReviewViewModel {
        ReviewViewModel(
            draft: draft,
            previewer: services,
            placer: services,
            keys: keys,
            router: router,
            tracker: tracker
        )
    }
}
