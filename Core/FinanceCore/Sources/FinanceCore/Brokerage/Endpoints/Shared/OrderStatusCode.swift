//
//  OrderStatusCode.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum OrderStatusCode: String, Sendable {
    case waitingForTrigger = "waiting_for_trigger"
    case waitingForPrice = "waiting_for_price"
    case scheduled
    case waitingForOpen = "waiting_for_open"
    case filled
    case cancelled
    case expired
    case rejected
}
