//
//  HeaderKey.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum HeaderKey: String, Sendable {
    case contentType = "Content-Type"
    case idempotencyKey = "Idempotency-Key"
}
