//
//  QuoteDetailIssuePresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

extension QuoteDetailIssue {
    var title: LocalizedStringResource {
        switch self {
        case .offline:
            .init("quoteDetail.placeholder.offline.title", bundle: .module)
        case .serviceUnavailable, .unreadableData:
            .init("quoteDetail.placeholder.unavailable.title", bundle: .module)
        }
    }

    var message: LocalizedStringResource {
        switch self {
        case .offline:
            .init("quoteDetail.placeholder.offline.message", bundle: .module)
        case .serviceUnavailable, .unreadableData:
            .init("quoteDetail.placeholder.unavailable.message", bundle: .module)
        }
    }

    var image: FinanceImage {
        switch self {
        case .offline:
            .offline
        case .serviceUnavailable, .unreadableData:
            .warning
        }
    }
}
