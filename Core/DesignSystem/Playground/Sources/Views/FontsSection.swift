//
//  FontsSection.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct FontsSection: View {
    var body: some View {
        Section {
            ForEach(FinanceFont.allCases, id: \.self) { font in
                Text(verbatim: String(describing: font))
                    .textStyle(FinanceColor.textPrimary, font)
            }
        } header: {
            Text(verbatim: "Fonts")
        }
    }
}

#if DEBUG
#Preview {
    List {
        FontsSection()
    }
}
#endif
