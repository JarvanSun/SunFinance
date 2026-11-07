//
//  TriggerKind.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum TriggerKind: String, CaseIterable, Hashable, Sendable {
    case now
    case price
    case time
}
