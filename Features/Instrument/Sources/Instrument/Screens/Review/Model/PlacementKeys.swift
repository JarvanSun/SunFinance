//
//  PlacementKeys.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

final class PlacementKeys {
    private var current: (draft: OrderDraft, key: IdempotencyKey)?

    func key(for draft: OrderDraft) -> IdempotencyKey {
        switch current {
        case .some(let current) where current.draft == draft:
            return current.key
        case .some, nil:
            let key = IdempotencyKey()
            current = (draft, key)
            return key
        }
    }

    func spend(_ key: IdempotencyKey) {
        guard current?.key == key else { return }

        current = nil
    }
}
