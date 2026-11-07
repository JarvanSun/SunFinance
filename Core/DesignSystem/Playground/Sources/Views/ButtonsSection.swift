//
//  ButtonsSection.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct ButtonsSection: View {
    var body: some View {
        Section {
            ForEach(FinanceButtonKind.allCases, id: \.self) { kind in
                kindButton(kind)

                kindButton(kind)
                    .disabled(true)
            }
        } header: {
            Text(verbatim: "Buttons: each kind enabled, then disabled")
        }
    }
}

private extension ButtonsSection {
    func kindButton(_ kind: FinanceButtonKind) -> some View {
        Button(action: {}) {
            Label {
                Text(verbatim: String(describing: kind))
            } icon: {
                Image(style: FinanceImage.favorite)
            }
            .labelStyle(.titleAndIcon)
        }
        .buttonStyle(.finance(kind))
        .accessibilityLabel(Text(verbatim: String(describing: kind)))
    }
}

#if DEBUG
#Preview {
    List {
        ButtonsSection()
    }
}
#endif
