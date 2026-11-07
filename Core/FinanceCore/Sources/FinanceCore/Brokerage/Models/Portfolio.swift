//
//  Portfolio.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct Portfolio: Hashable, Sendable {
    public let open: [Position]
    public let closed: [Position]

    public init(open: [Position], closed: [Position]) {
        self.open = open
        self.closed = closed
    }

    public func position(of symbol: TickerSymbol) -> Position? {
        open.first { $0.symbol == symbol }
    }
}

extension Portfolio {
    init(_ dto: PositionsResponseDTO) throws(BrokerageError) {
        try self.init(
            open: dto.open.map(Position.init(_:)),
            closed: dto.closed.map(Position.init(_:))
        )
    }
}
