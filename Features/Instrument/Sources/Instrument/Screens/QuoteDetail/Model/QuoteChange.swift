//
//  QuoteChange.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum QuoteChange: Equatable, Sendable {
    case pending
    case known(PriceChange)
}
