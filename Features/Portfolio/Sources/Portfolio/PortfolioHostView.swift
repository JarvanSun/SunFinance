//
//  PortfolioHostView.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

public struct PortfolioHostView: View {
    private let dependencies: PortfolioDependencies

    public init(dependencies: PortfolioDependencies) {
        self.dependencies = dependencies
    }

    public var body: some View {
        PortfolioNavigationHost(dependencies: dependencies)
    }
}

#if DEBUG
#Preview("Portfolio") {
    PortfolioHostView(dependencies: PreviewObjectPool.portfolioDependencies())
}
#endif
