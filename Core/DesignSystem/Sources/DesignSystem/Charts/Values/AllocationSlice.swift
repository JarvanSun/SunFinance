//
//  AllocationSlice.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct AllocationSlice: Identifiable, Hashable, Sendable {
    public enum Tone: Hashable, Sendable {
        case holding
        case neutral
    }

    public let id: String
    public let label: String
    public let value: Double
    public let tone: Tone

    public init(id: String, label: String, value: Double, tone: Tone = .holding) {
        self.id = id
        self.label = label
        self.value = value
        self.tone = tone
    }
}
