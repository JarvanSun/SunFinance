//
//  StateAction.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunUserInterface

public struct StateAction {
    public let title: LocalizedStringResource
    public let accessibilityIdentifier: String
    public let perform: () -> Void

    public init(title: LocalizedStringResource, perform: @escaping () -> Void) {
        self.title = title
        accessibilityIdentifier = ""
        self.perform = perform
    }

    public init(
        title: LocalizedStringResource,
        accessibilityIdentifier: some AccessibilityIdentifying,
        perform: @escaping () -> Void
    ) {
        self.title = title
        self.accessibilityIdentifier = accessibilityIdentifier.rawValue
        self.perform = perform
    }
}
