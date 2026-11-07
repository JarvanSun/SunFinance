//
//  PlacementState.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum PlacementState: Equatable, Sendable {
    case ready
    case placing
    case placed(Order)
    case failed(TradingIssue)
}
