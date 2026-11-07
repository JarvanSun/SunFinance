//
//  PortfolioValuePoint.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct PortfolioValuePoint: Hashable, Sendable {
    public let date: Date
    public let value: Money

    public init(date: Date, value: Money) {
        self.date = date
        self.value = value
    }
}

extension PortfolioValuePoint {
    init(_ dto: ValuePointDTO) throws(BrokerageError) {
        try self.init(date: dto.date, value: dto.value.money())
    }
}
