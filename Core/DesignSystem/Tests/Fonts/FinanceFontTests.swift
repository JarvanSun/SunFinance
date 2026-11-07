//
//  FinanceFontTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI
import Testing
import UIKit

@testable import DesignSystem

struct FinanceFontTests {
    @Test(arguments: FinanceFont.allCases)
    func styleThenUsesBundledFaceSoDynamicTypeScales(font: FinanceFont) {
        #expect(InterFace.allCases.contains(font.face))
        #expect(font.size == font.pointSize)
    }

    @Test(arguments: [
        (InterFace.regular, Font.Weight.regular),
        (.medium, .medium),
        (.semiBold, .semibold),
        (.bold, .bold),
    ])
    func faceWeightThenMatchesTheFaceSoSwiftUIKeepsIt(face: InterFace, weight: Font.Weight) {
        #expect(face.weight == weight)
    }

    @Test(arguments: FinanceFont.allCases)
    func fontThenItsBundledFaceIsRegistered(font: FinanceFont) {
        // Given / When
        _ = font.font

        // Then
        #expect(UIFont(name: font.face.postScriptName, size: font.pointSize) != nil)
    }
}
