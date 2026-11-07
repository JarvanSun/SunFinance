//
//  PositionsResponseDTO.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

struct PositionsResponseDTO: Codable, Sendable {
    let open: [PositionDTO]
    let closed: [PositionDTO]
}
