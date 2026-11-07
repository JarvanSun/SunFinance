//
//  ComponentsSection.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct ComponentsSection: View {
    @Environment(\.dimensions) private var dimensions
    @State private var quantity = "3"
    @State private var price = "0"
    @State private var range = "1D"
    @State private var side = "Buy"
    @State private var isShielded = false

    var body: some View {
        Section {
            LoadingStateView(title: "Loading quotes…")

            ContentUnavailableStateView(
                title: "No quotes yet",
                message: "Add a symbol to start your watchlist.",
                image: .emptyWatchlist
            )

            ContentUnavailableStateView(
                title: "You're offline",
                message: "Check your connection and try again.",
                image: .offline,
                action: StateAction(title: "Try again", perform: {})
            )

            DecimalField("Shares", text: $quantity)

            DecimalField("Limit price", text: $price, isInvalid: true)

            HeroAmount(Money(22_060.20, .eur))

            HeroAmount(Money(231.42, .usd), size: .row)

            MetricStrip([
                Metric(id: "invested", label: "Invested", value: "€9,848.84"),
                Metric(id: "return", label: "Total return", value: "+€250.46", trend: .gain),
            ])

            SectionHeading("Positions")

            SurfaceGroup {
                Text(verbatim: "Content on one surface")
                    .textStyle(FinanceColor.textPrimary, FinanceFont.body)
            }

            LabeledRows([
                LabeledRow(id: "fee", title: "Fee", value: .verbatim("€1.00")),
                LabeledRow(
                    id: "total",
                    title: "Estimated total",
                    value: .verbatim("€427.42"),
                    emphasis: .total
                ),
            ])

            FinanceSegmentedControl(
                options: ["Buy", "Sell"],
                selection: side,
                onSelect: { side = $0 },
                label: { Text(verbatim: $0) }
            )

            FinanceSegmentedControl(
                options: ["1D", "1W", "1M", "1Y"],
                selection: range,
                style: .quiet,
                onSelect: { range = $0 },
                label: { Text(verbatim: $0) }
            )

            Toggle(isOn: $isShielded) {
                Text(verbatim: "Privacy shield")
            }
            .tint(FinanceColor.accent.color)

            Text(verbatim: "€22,240.12 behind the shield")
                .textStyle(FinanceColor.textPrimary, FinanceFont.headline)
                .frame(maxWidth: .infinity, minHeight: dimensions.headerPlaceholderHeight)
                .privacyShield(isShielded: isShielded)

            ScrollView {
                Text(verbatim: "Content scrolls under the floating bar.")
                    .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: dimensions.placeholderMinimumHeight,
                        alignment: .top
                    )
            }
            .frame(height: dimensions.completionBadgeSize)
            .floatingBottomBar {
                Button(action: {}) {
                    Text(verbatim: "Floating action")
                }
                .buttonStyle(.finance(.primary))
            }
        } header: {
            Text(verbatim: "Components")
        }
    }
}

#if DEBUG
#Preview {
    List {
        ComponentsSection()
    }
}
#endif
