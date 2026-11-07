//
//  PortfolioIssuePresentation.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

extension PortfolioIssue {
    var title: LocalizedStringResource {
        switch self {
        case .offline: .init("portfolio.failure.offline.title", bundle: .module)
        case .serviceUnavailable: .init("portfolio.failure.service.title", bundle: .module)
        }
    }

    var message: LocalizedStringResource {
        switch self {
        case .offline: .init("portfolio.failure.offline.message", bundle: .module)
        case .serviceUnavailable: .init("portfolio.failure.service.message", bundle: .module)
        }
    }

    var image: FinanceImage {
        switch self {
        case .offline: .offline
        case .serviceUnavailable: .warning
        }
    }
}
