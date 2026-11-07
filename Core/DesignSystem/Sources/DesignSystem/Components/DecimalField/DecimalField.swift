//
//  DecimalField.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public struct DecimalField: View {
    @Environment(\.dimensions) private var dimensions
    @FocusState private var isFocused: Bool

    @Binding private var text: String

    private let title: LocalizedStringResource
    private let isInvalid: Bool

    public init(_ title: LocalizedStringResource, text: Binding<String>, isInvalid: Bool = false) {
        self.title = title
        _text = text
        self.isInvalid = isInvalid
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: dimensions.spaceXSmall) {
            Text(title)
                .textStyle(FinanceColor.textSecondary, FinanceFont.caption)

            TextField(text: $text) { Text(title) }
                .font(FinanceFont.body)
                .foregroundColor(FinanceColor.textPrimary)
                .monospacedDigit()
                .keyboardType(.decimalPad)
                .focused($isFocused)
                .padding(.horizontal, dimensions.spaceMedium)
                .frame(minHeight: dimensions.minimumTapTarget)
                .background(frame.fill(FinanceColor.surface.color))
                .overlay(
                    frame.stroke(
                        emphasis.borderColor.color,
                        lineWidth: emphasis.borderWidth(in: dimensions)
                    )
                )
                .contentShape(frame)
                .onTapGesture { isFocused = true }
        }
        .financeAnimation(.snappy, value: emphasis)
    }
}

private extension DecimalField {
    var emphasis: FieldEmphasis {
        FieldEmphasis(isFocused: isFocused, isInvalid: isInvalid)
    }

    var frame: RoundedRectangle {
        RoundedRectangle(cornerRadius: dimensions.cornerRadiusLarge, style: .continuous)
    }
}

#if DEBUG
private struct DecimalFieldPreview: View {
    @State private var quantity = "3"
    @State private var price = "0"

    var body: some View {
        VStack(spacing: 16) {
            DecimalField("Shares", text: $quantity)

            DecimalField("Limit price", text: $price, isInvalid: true)
        }
        .padding()
    }
}

#Preview {
    DecimalFieldPreview()
}
#endif
