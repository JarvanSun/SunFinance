//
//  OrderValidity.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum OrderValidity: String, CaseIterable, Hashable, Sendable {
    case day
    case goodTillCancelled = "gtc"
}
