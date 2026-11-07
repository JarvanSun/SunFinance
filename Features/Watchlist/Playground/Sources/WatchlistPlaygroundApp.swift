//
//  WatchlistPlaygroundApp.swift
//  WatchlistPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI
import Watchlist

@main
struct WatchlistPlaygroundApp: App {
    @State private var dependencies = PlaygroundDependencies()

    var body: some Scene {
        WindowGroup {
            WatchlistHostView(dependencies: dependencies.watchlist())
        }
    }
}
