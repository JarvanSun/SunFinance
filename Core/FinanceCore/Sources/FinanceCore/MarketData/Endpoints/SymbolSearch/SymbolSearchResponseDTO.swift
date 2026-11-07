//
//  SymbolSearchResponseDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

struct SymbolSearchResponseDTO: Codable, Sendable {
    let matches: [SymbolMatchDTO]
}
