//
//  AccountProviding.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public protocol AccountProviding: Sendable {
    func account() async throws(BrokerageError) -> Account
}
