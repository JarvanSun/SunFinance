//
//  FinanceButtonStyle.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public struct FinanceButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.dimensions) private var dimensions

    private let kind: FinanceButtonKind

    public init(kind: FinanceButtonKind) {
        self.kind = kind
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(kind.font)
            .foregroundColor(kind.foreground)
            .multilineTextAlignment(.center)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .frame(
                minWidth: dimensions.minimumTapTarget,
                maxWidth: maximumWidth,
                minHeight: dimensions.minimumTapTarget
            )
            .background { background(isPressed: configuration.isPressed) }
            .contentShape(shape)
            .opacity(opacity(isPressed: configuration.isPressed))
    }
}

private extension FinanceButtonStyle {
    var pressedOpacity: Double { 0.7 }

    var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: dimensions.cornerRadiusLarge, style: .continuous)
    }

    var verticalPadding: CGFloat {
        kind.hasPadding ? dimensions.spaceMedium : .zero
    }

    var horizontalPadding: CGFloat {
        kind.hasPadding ? dimensions.spaceLargeSmall : .zero
    }

    var maximumWidth: CGFloat? {
        kind.fillsWidth ? .infinity : nil
    }

    func opacity(isPressed: Bool) -> Double {
        switch (isEnabled, isPressed && kind.dimsWhenPressed) {
        case (false, _):
            FinanceOpacity.dimmed.value
        case (true, true):
            pressedOpacity
        case (true, false):
            1
        }
    }

    func background(isPressed: Bool) -> some View {
        ZStack {
            shape.fill(kind.fill(isPressed: isPressed)?.color ?? .clear)

            shape.stroke(kind.border?.color ?? .clear, lineWidth: dimensions.borderWidthSmall)
        }
    }
}

#if DEBUG
#Preview("Buttons") {
    ScrollView {
        VStack(spacing: 12) {
            ForEach(FinanceButtonKind.allCases, id: \.self) { kind in
                ForEach([true, false], id: \.self) { isEnabled in
                    Button(action: {}) {
                        Text(verbatim: "\(kind)\(isEnabled ? "" : ", disabled")")
                    }
                    .buttonStyle(.finance(kind))
                    .disabled(!isEnabled)
                }
            }
        }
        .padding()
    }
}
#endif
