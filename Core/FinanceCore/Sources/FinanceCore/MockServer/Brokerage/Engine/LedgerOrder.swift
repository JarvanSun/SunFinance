//
//  LedgerOrder.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct LedgerOrder: Equatable, Sendable {
    enum State: String, Codable, Sendable {
        case working
        case filled
        case cancelled
        case expired
        case rejected
    }

    let id: Order.ID
    let draft: OrderDraft
    let quantity: Decimal
    let createdAt: Date
    var state: State
    var releasedAt: Date?
    var rejection: OrderRejection?
    var fillID: String?
}

extension LedgerOrder: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case draft
        case quantity
        case createdAt
        case state
        case releasedAt
        case rejection
        case fillID
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rejection = try container.decodeIfPresent(String.self, forKey: .rejection)
        self.init(
            id: try container.decode(Order.ID.self, forKey: .id),
            draft: try OrderDraft(container.decode(OrderDraftDTO.self, forKey: .draft)),
            quantity: try container.decode(Decimal.self, forKey: .quantity),
            createdAt: try container.decode(Date.self, forKey: .createdAt),
            state: try container.decode(State.self, forKey: .state),
            releasedAt: try container.decodeIfPresent(Date.self, forKey: .releasedAt),
            rejection: try rejection.map { rawValue in
                guard let rejection = OrderRejection(rawValue: rawValue) else {
                    throw DecodingError.dataCorruptedError(
                        forKey: .rejection,
                        in: container,
                        debugDescription: rawValue
                    )
                }
                return rejection
            },
            fillID: try container.decodeIfPresent(String.self, forKey: .fillID)
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(draft.dto, forKey: .draft)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(state, forKey: .state)
        try container.encodeIfPresent(releasedAt, forKey: .releasedAt)
        try container.encodeIfPresent(rejection?.rawValue, forKey: .rejection)
        try container.encodeIfPresent(fillID, forKey: .fillID)
    }
}
