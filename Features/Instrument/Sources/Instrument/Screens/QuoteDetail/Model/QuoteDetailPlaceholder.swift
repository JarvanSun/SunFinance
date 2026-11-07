//
//  QuoteDetailPlaceholder.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum QuoteDetailPlaceholder: Equatable, Sendable {
    case loading
    case failed(QuoteDetailIssue)
}
