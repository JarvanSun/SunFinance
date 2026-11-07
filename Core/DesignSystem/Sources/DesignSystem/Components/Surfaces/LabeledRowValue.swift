//
//  LabeledRowValue.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public enum LabeledRowValue: Equatable, Sendable {
    case verbatim(String)
    case localized(LocalizedStringResource)
}
