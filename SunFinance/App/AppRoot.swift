//
//  AppRoot.swift
//  SunFinance
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SwiftUI

struct AppRoot: View {
    @Environment(\.scenePhase) private var scenePhase

    let dependencies: AppDependencies

    var body: some View {
        MainTabsView(dependencies: dependencies)
            .background(FinanceColor.background.color.ignoresSafeArea())
            .privacyShield(isShielded: scenePhase != .active)
    }
}
