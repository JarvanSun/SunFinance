//
//  StandInScreen.swift
//  WatchlistPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct StandInScreen: View {
    let title: String

    var body: some View {
        Text(verbatim: title)
            .textStyle(FinanceColor.textSecondary, FinanceFont.body)
            .navigationTitle(Text(verbatim: title))
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        StandInScreen(title: "Quote detail AAPL")
    }
}
#endif
