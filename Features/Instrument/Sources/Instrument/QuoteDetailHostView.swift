//
//  QuoteDetailHostView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

public struct QuoteDetailHostView: View {
    private let dependencies: QuoteDetailDependencies

    public init(dependencies: QuoteDetailDependencies) {
        self.dependencies = dependencies
    }

    public var body: some View {
        QuoteDetailNavigationHost(dependencies: dependencies)
    }
}

#if DEBUG
#Preview("Quote Detail") {
    NavigationStack {
        QuoteDetailHostView(dependencies: PreviewObjectPool().quoteDetailDependencies())
    }
}
#endif
