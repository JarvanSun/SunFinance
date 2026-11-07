//
//  PriceCandle.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct PriceCandle: Hashable, Sendable {
    public let start: Date
    public let open: Decimal
    public let high: Decimal
    public let low: Decimal
    public let close: Decimal
    public let volume: Int

    public init(
        start: Date,
        open: Decimal,
        high: Decimal,
        low: Decimal,
        close: Decimal,
        volume: Int
    ) {
        self.start = start
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
    }
}

extension PriceCandle {
    init(_ dto: CandleDTO) {
        self.init(
            start: dto.start,
            open: dto.open,
            high: dto.high,
            low: dto.low,
            close: dto.close,
            volume: dto.volume
        )
    }
}
