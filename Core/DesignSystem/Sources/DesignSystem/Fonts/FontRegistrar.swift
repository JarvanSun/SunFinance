//
//  FontRegistrar.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import CoreText
import Foundation

nonisolated enum FontRegistrar {
    static let registration: Void = registerBundledFonts()
}

private extension FontRegistrar {
    nonisolated static var fontFileExtension: String { "ttf" }

    nonisolated static func registerBundledFonts() {
        for face in InterFace.allCases {
            register(face)
        }
    }

    nonisolated static func register(_ face: InterFace) {
        let url = Bundle.designSystem.url(
            forResource: face.rawValue,
            withExtension: fontFileExtension
        )
        guard let url else { return }

        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
}
