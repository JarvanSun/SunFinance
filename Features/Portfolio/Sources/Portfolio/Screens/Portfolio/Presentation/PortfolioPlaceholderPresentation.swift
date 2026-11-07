//
//  PortfolioPlaceholderPresentation.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

extension PortfolioPlaceholder {
    var title: LocalizedStringResource {
        switch self {
        case .loading: .init("portfolio.loading", bundle: .module)
        case .empty: .init("portfolio.empty.title", bundle: .module)
        case .failed(let issue): issue.title
        }
    }

    var message: LocalizedStringResource {
        switch self {
        case .loading, .empty: .init("portfolio.empty.message", bundle: .module)
        case .failed(let issue): issue.message
        }
    }

    var image: FinanceImage {
        switch self {
        case .loading, .empty: .emptyWatchlist
        case .failed(let issue): issue.image
        }
    }
}
