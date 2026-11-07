//
//  ButtonStyleExtensions.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

extension ButtonStyle where Self == FinanceButtonStyle {
    public static func finance(_ kind: FinanceButtonKind) -> Self {
        FinanceButtonStyle(kind: kind)
    }
}
