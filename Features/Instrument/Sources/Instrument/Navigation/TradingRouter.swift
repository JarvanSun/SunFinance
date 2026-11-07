//
//  TradingRouter.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Observation
import SunUserInterface

@Observable
final class TradingRouter: FeatureRouting, TradingRouting {
    var presentation: FeaturePresentation<TradingDestination>?
    var path: [TradingDestination] = []
    private(set) var closeRequest = 0

    @ObservationIgnored var makeReviewViewModel: ((OrderDraft) -> ReviewViewModel)?

    func view(for destination: TradingDestination) -> TradingDestinationView {
        .init(destination: destination, makeReviewViewModel: makeReviewViewModel)
    }

    func showReview(of draft: OrderDraft) {
        route(to: TradingDestination.review(draft))
    }

    func returnToTicket() {
        path = []
    }

    func close() {
        closeRequest += 1
    }
}
