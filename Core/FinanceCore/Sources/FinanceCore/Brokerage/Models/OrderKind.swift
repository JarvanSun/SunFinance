//
//  OrderKind.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum OrderKind: String, CaseIterable, Hashable, Sendable {
    case market
    case limit
    case stop
    case stopLimit = "stop_limit"
}
