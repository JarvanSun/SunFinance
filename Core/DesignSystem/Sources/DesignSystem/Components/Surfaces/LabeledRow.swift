//
//  LabeledRow.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct LabeledRow: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: LocalizedStringResource
    public let value: LabeledRowValue
    public let emphasis: LabeledRowEmphasis

    public init(
        id: String,
        title: LocalizedStringResource,
        value: LabeledRowValue,
        emphasis: LabeledRowEmphasis = .regular
    ) {
        self.id = id
        self.title = title
        self.value = value
        self.emphasis = emphasis
    }
}
