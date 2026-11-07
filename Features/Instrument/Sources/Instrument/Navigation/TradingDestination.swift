//
//  TradingDestination.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import SunUserInterface

nonisolated enum TradingDestination: FeatureDestination {
    case root
    case review(OrderDraft)
}
