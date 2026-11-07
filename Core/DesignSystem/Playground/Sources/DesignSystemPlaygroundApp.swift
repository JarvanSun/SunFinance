//
//  DesignSystemPlaygroundApp.swift
//  DesignSystemPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

@main
struct DesignSystemPlaygroundApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab {
                    CatalogView()
                } label: {
                    Text(verbatim: "Catalogue")
                }

                Tab {
                    ChartGalleryView()
                } label: {
                    Text(verbatim: "Charts")
                }
            }
        }
    }
}
