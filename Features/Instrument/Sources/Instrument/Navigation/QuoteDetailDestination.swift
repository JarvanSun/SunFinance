//
//  QuoteDetailDestination.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import SunUserInterface

nonisolated enum QuoteDetailDestination: FeatureDestination {
    case root
    case orderTicket(TradeIntent)
}
