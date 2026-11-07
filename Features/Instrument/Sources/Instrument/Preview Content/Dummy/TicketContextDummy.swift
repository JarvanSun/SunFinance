//
//  TicketContextDummy.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

extension TicketContext {
    nonisolated static func dummy(isMarketOpen: Bool) -> TicketContext {
        .init(
            quote: .dummy(isMarketOpen: isMarketOpen),
            buyingPower: Account.dummy.buyingPower,
            heldShares: Position.dummy.quantity
        )
    }
}
#endif
