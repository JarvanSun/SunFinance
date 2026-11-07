//
//  ChartPointDummy.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

@testable import DesignSystem

extension ChartPoint {
    static func dummySeries(count: Int) -> [ChartPoint] {
        (0..<count).map {
            ChartPoint(date: Date(timeIntervalSince1970: Double($0) * 60), value: Double($0))
        }
    }
}
