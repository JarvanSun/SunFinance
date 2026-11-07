//
//  ImagesSection.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct ImagesSection: View {
    @Environment(\.dimensions) private var dimensions

    var body: some View {
        Section {
            ForEach(FinanceImage.allCases, id: \.self) { image in
                Label {
                    Text(verbatim: image.rawValue)
                } icon: {
                    Image(style: image)
                }
                .textStyle(FinanceColor.textPrimary, FinanceFont.body)
                .labelStyle(.titleAndIcon)
                .padding(.vertical, dimensions.spaceXSmall)
            }
        } header: {
            Text(verbatim: "Images")
        }
    }
}

#if DEBUG
#Preview {
    List {
        ImagesSection()
    }
}
#endif
