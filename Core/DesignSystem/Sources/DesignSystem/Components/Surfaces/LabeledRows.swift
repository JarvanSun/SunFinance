//
//  LabeledRows.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public struct LabeledRows: View {
    @Environment(\.dimensions) private var dimensions
    @Environment(\.displayScale) private var displayScale

    private let rows: [LabeledRow]

    public init(_ rows: [LabeledRow]) {
        self.rows = rows
    }

    public var body: some View {
        VStack(spacing: hairline) {
            ForEach(rows) { row in
                HStack(alignment: .firstTextBaseline, spacing: dimensions.spaceMedium) {
                    Text(row.title)
                        .textStyle(row.emphasis.titleColor, row.emphasis.font)

                    Spacer(minLength: dimensions.spaceMedium)

                    valueText(row.value)
                        .textStyle(FinanceColor.textPrimary, row.emphasis.font)
                        .monospacedDigit()
                        .multilineTextAlignment(.trailing)
                }
                .padding(.vertical, dimensions.spaceMedium)
                .background(FinanceColor.surface.color)
                .accessibilityElement(children: .combine)
            }
        }
        .background(FinanceColor.separator.color)
        .padding(.horizontal, dimensions.spaceLargeSmall)
        .background(surface.fill(FinanceColor.surface.color))
        .clipShape(surface)
    }
}

private extension LabeledRows {
    var hairline: CGFloat { 1 / displayScale }

    var surface: RoundedRectangle {
        .init(cornerRadius: dimensions.cornerRadiusLarge, style: .continuous)
    }

    func valueText(_ value: LabeledRowValue) -> Text {
        switch value {
        case .verbatim(let text): .init(verbatim: text)
        case .localized(let resource): .init(resource)
        }
    }
}

#if DEBUG
#Preview("Labeled rows") {
    ScrollView {
        VStack(spacing: 24) {
            LabeledRows([
                LabeledRow(id: "quantity", title: "Shares", value: .verbatim("2")),
                LabeledRow(id: "price", title: "Price per share", value: .verbatim("$231.42")),
                LabeledRow(id: "rate", title: "Exchange rate", value: .verbatim("1 USD = €0.9213")),
                LabeledRow(id: "fee", title: "Fee", value: .verbatim("€1.00")),
                LabeledRow(
                    id: "total",
                    title: "Estimated total",
                    value: .verbatim("€427.42"),
                    emphasis: .total
                ),
            ])

            LabeledRows([
                LabeledRow(id: "type", title: "Order type", value: .localized("Limit $235.00")),
                LabeledRow(id: "validity", title: "Valid", value: .localized("Until cancelled")),
            ])

            LabeledRows([LabeledRow(id: "one", title: "One row", value: .verbatim("€1.00"))])
        }
        .padding()
    }
    .background(FinanceColor.background.color)
}
#endif
