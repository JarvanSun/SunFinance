//
//  FontRegistrar.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import CoreText
import Foundation
import UIKit

nonisolated struct FontRegistrar {
    func registerBundledFonts() {
        for face in InterFace.allCases where !isRegistered(face) {
            register(face)
        }
    }
}

private extension FontRegistrar {
    nonisolated var fontFileExtension: String { "ttf" }

    nonisolated func isRegistered(_ face: InterFace) -> Bool {
        UIFont(name: face.postScriptName, size: UIFont.systemFontSize) != nil
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
