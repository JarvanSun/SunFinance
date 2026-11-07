//
//  OrderTriggerKind.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum OrderTriggerKind: String, CaseIterable, Hashable, Sendable {
    case now
    case price
    case time
}
