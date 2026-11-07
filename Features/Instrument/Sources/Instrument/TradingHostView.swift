//
//  TradingHostView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

public struct TradingHostView: View {
    private let dependencies: TradingDependencies

    public init(dependencies: TradingDependencies) {
        self.dependencies = dependencies
    }

    public var body: some View {
        TradingNavigationHost(dependencies: dependencies)
    }
}

#if DEBUG
#Preview("Trading") {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            TradingHostView(dependencies: PreviewObjectPool().tradingDependencies())
        }
}
#endif
