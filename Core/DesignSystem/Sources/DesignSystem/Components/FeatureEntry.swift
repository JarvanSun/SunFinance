//
//  FeatureEntry.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

public struct FeatureEntry<Input> {
    private let makeView: (Input) -> AnyView

    public init<Content: View>(@ViewBuilder _ makeView: @escaping (Input) -> Content) {
        self.makeView = { AnyView(makeView($0)) }
    }

    public func view(for input: Input) -> AnyView {
        makeView(input)
    }
}
