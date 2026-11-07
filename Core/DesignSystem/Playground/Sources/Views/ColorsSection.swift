//
//  ColorsSection.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct ColorsSection: View {
    @Environment(\.dimensions) private var dimensions

    var body: some View {
        Section {
            ForEach(FinanceColor.allCases, id: \.self) { color in
                HStack(spacing: dimensions.spaceMedium) {
                    RoundedRectangle(cornerRadius: dimensions.cornerRadiusSmall)
                        .fill(color.color)
                        .stroke(
                            FinanceColor.separator.color,
                            lineWidth: dimensions.borderWidthXSmall
                        )
                        .frame(
                            width: dimensions.minimumTapTarget,
                            height: dimensions.minimumTapTarget
                        )

                    Text(verbatim: color.rawValue)
                        .textStyle(FinanceColor.textPrimary, FinanceFont.body)
                }
            }
        } header: {
            Text(verbatim: "Colors")
        }
    }
}

#if DEBUG
#Preview {
    List {
        ColorsSection()
    }
}
#endif
