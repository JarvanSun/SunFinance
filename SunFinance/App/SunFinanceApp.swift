//
//  SunFinanceApp.swift
//  SunFinance
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

@main
struct SunFinanceApp: App {
    @State private var dependencies: AppDependencies

    init() {
        _dependencies = State(initialValue: AppDependencies(configuration: .dummy))
    }

    var body: some Scene {
        WindowGroup {
            AppRoot(dependencies: dependencies)
        }
    }
}
