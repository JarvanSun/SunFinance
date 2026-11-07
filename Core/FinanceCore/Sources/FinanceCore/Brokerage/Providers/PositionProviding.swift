//
//  PositionProviding.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public protocol PositionProviding: Sendable {
    func portfolio() async throws(BrokerageError) -> Portfolio
}
