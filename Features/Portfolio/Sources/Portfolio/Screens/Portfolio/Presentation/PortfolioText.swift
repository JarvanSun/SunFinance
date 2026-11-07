//
//  PortfolioText.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

enum PortfolioText {
    static var title: LocalizedStringResource {
        .init("portfolio.title", bundle: .module)
    }

    static var chartTitle: LocalizedStringResource {
        .init("portfolio.chart.title", bundle: .module)
    }

    static var chartUnavailable: LocalizedStringResource {
        .init("portfolio.chart.unavailable", bundle: .module)
    }

    static var allocationTitle: LocalizedStringResource {
        .init("portfolio.allocation.title", bundle: .module)
    }

    static var cash: LocalizedStringResource {
        .init("portfolio.allocation.cash", bundle: .module)
    }

    static var positions: LocalizedStringResource {
        .init("portfolio.allocation.positions", bundle: .module)
    }

    static var today: LocalizedStringResource {
        .init("portfolio.metric.today", bundle: .module)
    }

    static var totalReturn: LocalizedStringResource {
        .init("portfolio.metric.totalReturn", bundle: .module)
    }

    static var invested: LocalizedStringResource {
        .init("portfolio.metric.invested", bundle: .module)
    }

    static var positionsTitle: LocalizedStringResource {
        .init("portfolio.positions.title", bundle: .module)
    }

    static var closedTitle: LocalizedStringResource {
        .init("portfolio.closed.title", bundle: .module)
    }

    static var realizedLabel: LocalizedStringResource {
        .init("portfolio.closed.realizedLabel", bundle: .module)
    }

    static var loading: LocalizedStringResource {
        .init("portfolio.loading", bundle: .module)
    }

    static var retry: LocalizedStringResource {
        .init("portfolio.failure.retry", bundle: .module)
    }
}
