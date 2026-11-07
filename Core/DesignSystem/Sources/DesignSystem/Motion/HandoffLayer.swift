//
//  HandoffLayer.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct HandoffLayer<Value: Hashable>: Identifiable {
    let id = UUID()
    let value: Value
    var phase: HandoffPhase
}
