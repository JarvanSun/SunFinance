//
//  PortfolioDestination.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import SunUserInterface

nonisolated enum PortfolioDestination: FeatureDestination {
    case root
    case quoteDetail(TickerSymbol)
    case orderTicket(TradeIntent)
}
