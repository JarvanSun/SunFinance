//
//  PortfolioHistoryResponseDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

struct PortfolioHistoryResponseDTO: Codable, Sendable {
    let range: String
    let points: [ValuePointDTO]
}
