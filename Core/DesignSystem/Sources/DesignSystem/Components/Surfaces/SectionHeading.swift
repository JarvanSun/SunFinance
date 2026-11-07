//
//  SectionHeading.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public struct SectionHeading<Accessory: View>: View {
    @Environment(\.dimensions) private var dimensions

    private let title: LocalizedStringResource
    private let accessory: Accessory

    public init(_ title: LocalizedStringResource, @ViewBuilder accessory: () -> Accessory) {
        self.title = title
        self.accessory = accessory()
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .textStyle(FinanceColor.textPrimary, FinanceFont.title)
                .accessibilityAddTraits(.isHeader)

            Spacer(minLength: dimensions.spaceMedium)

            accessory
        }
        .padding(.horizontal, dimensions.spaceXSmall)
    }
}

extension SectionHeading where Accessory == EmptyView {
    public init(_ title: LocalizedStringResource) {
        self.init(title) { EmptyView() }
    }
}

#if DEBUG
#Preview("Section heading") {
    VStack(alignment: .leading, spacing: 24) {
        SectionHeading("Positions")

        SectionHeading("Allocation") {
            Button(action: {}) {
                Text(verbatim: "Show all")
            }
            .buttonStyle(.finance(.tertiary))
        }
    }
    .padding()
}
#endif
