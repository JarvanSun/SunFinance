//
//  PortfolioHistory.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct PortfolioHistory: Hashable, Sendable {
    public let range: HistoryRange
    public let points: [PortfolioValuePoint]

    public init(range: HistoryRange, points: [PortfolioValuePoint]) {
        self.range = range
        self.points = points
    }
}

extension PortfolioHistory {
    init(_ dto: PortfolioHistoryResponseDTO) throws(BrokerageError) {
        guard let range = HistoryRange(rawValue: dto.range) else { throw .decoding }

        try self.init(range: range, points: dto.points.map(PortfolioValuePoint.init(_:)))
    }
}
