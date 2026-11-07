//
//  QuotesResponseDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

struct QuotesResponseDTO: Codable, Sendable {
    let quotes: [QuoteDTO]
}
