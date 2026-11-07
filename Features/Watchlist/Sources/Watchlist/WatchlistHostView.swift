//
//  WatchlistHostView.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

public struct WatchlistHostView: View {
    private let dependencies: WatchlistDependencies

    public init(dependencies: WatchlistDependencies) {
        self.dependencies = dependencies
    }

    public var body: some View {
        WatchlistNavigationHost(dependencies: dependencies)
    }
}

#if DEBUG
#Preview("Watchlist") {
    WatchlistHostView(dependencies: PreviewObjectPool().watchlistDependencies())
}
#endif
