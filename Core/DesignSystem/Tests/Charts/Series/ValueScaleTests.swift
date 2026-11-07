//
//  ValueScaleTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import DesignSystem

struct ValueScaleTests {
    @Test func domainThenIncludesExtraValuesWithPadding() {
        // Given
        let scale = ValueScale(values: [10, 20])

        // When
        let domain = scale.domain(including: [-50, 500])

        // Then
        #expect(domain.lowerBound < -50)
        #expect(domain.upperBound > 500)
    }

    @Test func domainWhenFlatThenStillHasAMinimumHeight() {
        // Given
        let scale = ValueScale(values: [5, 5])

        // When
        let domain = scale.domain(including: [])

        // Then
        #expect(domain.lowerBound < 5)
        #expect(domain.upperBound > 5)
    }

    @Test func domainWhenEmptyThenFallsBackToTheUnitRange() {
        // Given
        let scale = ValueScale(values: [])

        // When
        let domain = scale.domain(including: [])

        // Then
        #expect(domain.lowerBound < 0)
        #expect(domain.upperBound > 1)
    }

    @Test(arguments: [(3.0, 1.0), (45, 10), (1_234, 100), (0.5, 0.1)])
    func roundStepThenSplitsTheSpanIntoAFewSteps(span: Double, expected: Double) {
        // Given
        let scale = ValueScale(values: [])

        // When
        let step = scale.roundStep(for: span)

        // Then
        #expect(abs(step - expected) < 0.000_001)
    }

    @Test func guideValuesThenAreRoundValuesAroundTheExtremes() {
        // Given
        let scale = ValueScale(values: [212.4, 230.9, 218])

        // When
        let guides = scale.guideValues

        // Then
        #expect(guides == [212, 231])
    }

    @Test(arguments: [[Double](), [5, 5]])
    func guideValuesWhenThereIsNoSpanThenAreEmpty(values: [Double]) {
        // Given
        let scale = ValueScale(values: values)

        // Then
        #expect(scale.guideValues.isEmpty)
    }
}
