//
//  OrderStatus.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum OrderStatus: Hashable, Sendable {
    case waitingForTrigger
    case waitingForPrice
    case scheduled
    case waitingForOpen
    case filled
    case cancelled
    case expired
    case rejected(OrderRejection)

    public var isOpen: Bool {
        switch self {
        case .waitingForTrigger, .waitingForPrice, .scheduled, .waitingForOpen: true
        case .filled, .cancelled, .expired, .rejected: false
        }
    }
}

extension OrderStatus {
    init?(code: String, rejection: String?) {
        let rejection = rejection.flatMap(OrderRejection.init(rawValue:))
        switch (OrderStatusCode(rawValue: code), rejection) {
        case (.waitingForTrigger, _):
            self = .waitingForTrigger
        case (.waitingForPrice, _):
            self = .waitingForPrice
        case (.scheduled, _):
            self = .scheduled
        case (.waitingForOpen, _):
            self = .waitingForOpen
        case (.filled, _):
            self = .filled
        case (.cancelled, _):
            self = .cancelled
        case (.expired, _):
            self = .expired
        case (.rejected, .some(let rejection)):
            self = .rejected(rejection)
        case (.rejected, nil), (nil, _):
            return nil
        }
    }
}
