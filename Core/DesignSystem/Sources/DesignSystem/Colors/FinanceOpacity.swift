//
//  FinanceOpacity.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

enum FinanceOpacity: CaseIterable, Sendable {
    case dimmed

    var value: Double {
        switch self {
        case .dimmed: 0.4
        }
    }
}

#if DEBUG
#Preview("Opacities") {
    VStack(alignment: .leading, spacing: 12) {
        ForEach(FinanceOpacity.allCases, id: \.self) { opacity in
            Text(verbatim: "\(opacity) \(opacity.value)")
                .textStyle(FinanceColor.textPrimary, FinanceFont.headline)
                .opacity(opacity.value)
        }
    }
    .padding()
}
#endif
