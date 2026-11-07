//
//  SymbolSearchRequest.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct SymbolSearchRequest: Hashable, Sendable {
    let query: String
    let attempt: UUID
}
