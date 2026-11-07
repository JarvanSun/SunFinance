//
//  TicketSection.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct TicketSection<Content: View>: View {
    @Environment(\.dimensions) private var dimensions

    let title: LocalizedStringResource
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: dimensions.spaceSmall) {
            Text(title)
                .textStyle(FinanceColor.textSecondary, FinanceFont.caption)
                .textCase(.uppercase)
                .accessibilityAddTraits(.isHeader)

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
