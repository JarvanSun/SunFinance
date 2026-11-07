//
//  FontRegistrar.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import CoreText
import Foundation

nonisolated struct FontRegistrar {
    func registerBundledFonts() {
        _ = registration
    }
}

private extension FontRegistrar {
    nonisolated var fontFileExtension: String { "ttf" }

    nonisolated func registerEveryFace() {
        for face in InterFace.allCases {
            register(face)
        }
    }

    nonisolated func register(_ face: InterFace) {
        let url = Bundle.module.url(
            forResource: face.rawValue,
            withExtension: fontFileExtension
        )
        guard let url else { return }

        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
}

private nonisolated let registration: Void = FontRegistrar().registerEveryFace()
