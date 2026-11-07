//
//  CatalogView.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

struct CatalogView: View {
    var body: some View {
        NavigationStack {
            List {
                ColorsSection()

                FontsSection()

                ImagesSection()

                ButtonsSection()

                ComponentsSection()

                MotionSection()

                DimensionsSection()
            }
            .navigationTitle(Text(verbatim: "DesignSystem"))
        }
    }
}

#if DEBUG
#Preview {
    CatalogView()
}
#endif
