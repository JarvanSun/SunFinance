//
//  FontRegistrarTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing
import UIKit

@testable import DesignSystem

struct FontRegistrarTests {
    @Test(arguments: InterFace.allCases)
    func registerBundledFontsThenEveryFaceIsAvailable(face: InterFace) {
        // When
        FontRegistrar().registerBundledFonts()

        // Then
        #expect(UIFont(name: face.postScriptName, size: 17) != nil)
    }
}
