//
//  PlacementStatePresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

extension PlacementState {
    var slidePhase: SlideToConfirmPhase {
        switch self {
        case .ready, .failed: .ready
        case .placing: .working
        case .placed: .done
        }
    }

    var isFailed: Bool {
        switch self {
        case .failed: true
        case .ready, .placing, .placed: false
        }
    }

    var failureMessage: LocalizedStringResource {
        switch self {
        case .failed(let issue): issue.placementMessage
        case .ready, .placing, .placed: TradingIssue.serviceUnavailable.placementMessage
        }
    }
}
