//
//  PositionActionsMenu.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct PositionActionsMenu: View {
    let onSelect: (PositionAction) -> Void

    var body: some View {
        ForEach(PositionAction.allCases, id: \.self) { action in
            Button(role: action.role) {
                onSelect(action)
            } label: {
                Label {
                    Text(action.title)
                } icon: {
                    Image(style: action.image)
                }
            }
        }
    }
}
