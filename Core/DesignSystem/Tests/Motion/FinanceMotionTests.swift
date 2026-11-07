//
//  FinanceMotionTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import DesignSystem

struct FinanceMotionTests {
    @Test(arguments: [
        (FinanceMotion.snappy, 0.25, 0.0),
        (.settle, 0.45, 0.15),
        (.reveal, 0.35, 0.0),
        (.emphasis, 0.6, 0.35),
        (.draw, 0.9, 0.0),
        (.shake, 0.06, 0.0),
        (.shimmer, 2.4, 0.0),
        (.pulse, 2.0, 0.0),
    ])
    func timingThenIsNamedPerMotion(motion: FinanceMotion, duration: Double, bounce: Double) {
        #expect(motion.duration == duration)
        #expect(motion.bounce == bounce)
    }

    @Test(arguments: FinanceMotion.allCases)
    func animationWhenReduceMotionThenIsNil(motion: FinanceMotion) {
        #expect(motion.animation(reduceMotion: true) == nil)
        #expect(motion.animation(reduceMotion: false) == motion.animation)
    }
}
