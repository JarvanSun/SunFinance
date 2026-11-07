//
//  SurfaceGroup.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public struct SurfaceGroup<Content: View>: View {
    @Environment(\.dimensions) private var dimensions

    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            content
        }
        .padding(dimensions.spaceLargeSmall)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(surface.fill(FinanceColor.surface.color))
        .clipShape(surface)
    }
}

private extension SurfaceGroup {
    var surface: RoundedRectangle {
        RoundedRectangle(cornerRadius: dimensions.cornerRadiusSurface, style: .continuous)
    }
}

#if DEBUG
#Preview("Surfaces") {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeading("Positions")

            SurfaceGroup {
                ForEach(["SAP", "AAPL", "NVDA"], id: \.self) { symbol in
                    Text(verbatim: symbol)
                        .textStyle(FinanceColor.textPrimary, FinanceFont.headline)
                        .padding(.vertical, 12)
                }
            }

            SurfaceGroup {
                Text(verbatim: "One line")
                    .textStyle(FinanceColor.textPrimary, FinanceFont.body)
            }
        }
        .padding()
    }
    .background(FinanceColor.background.color)
}
#endif
