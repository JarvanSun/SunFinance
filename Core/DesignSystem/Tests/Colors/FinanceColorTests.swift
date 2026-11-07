//
//  FinanceColorTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing
import UIKit

@testable import DesignSystem

struct FinanceColorTests {
    @Test(arguments: FinanceColor.allCases)
    func colorThenEveryCaseHasAnAsset(color: FinanceColor) {
        // When
        let asset = UIColor(named: color.rawValue, in: .module, compatibleWith: nil)

        // Then
        #expect(asset != nil)
    }
}
