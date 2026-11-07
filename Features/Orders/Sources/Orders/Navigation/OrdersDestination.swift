//
//  OrdersDestination.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import SunUserInterface

nonisolated enum OrdersDestination: FeatureDestination {
    case root
    case detail(Order)
    case quoteDetail(TickerSymbol)
}
