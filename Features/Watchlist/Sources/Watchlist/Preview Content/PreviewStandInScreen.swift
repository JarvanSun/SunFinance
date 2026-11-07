//
//  PreviewStandInScreen.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import DesignSystem
import SunUserInterface
import SwiftUI

struct PreviewStandInScreen: View {
    let title: String

    var body: some View {
        Text(verbatim: title)
            .textStyle(FinanceColor.textSecondary, FinanceFont.body)
            .navigationTitle(Text(verbatim: title))
    }
}
#endif
