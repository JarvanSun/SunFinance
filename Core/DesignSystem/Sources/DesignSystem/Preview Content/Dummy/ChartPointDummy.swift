//
//  ChartPointDummy.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import Foundation

extension ChartPoint {
    static var dummyRising: [ChartPoint] {
        dummyWave(from: 212, slope: 0.12)
    }

    static var dummyFalling: [ChartPoint] {
        dummyWave(from: 232, slope: -0.1)
    }

    static var dummyFlat: [ChartPoint] {
        dummyWave(from: 220, slope: 0, amplitude: 0)
    }

    static var dummyCandlePoints: [ChartPoint] {
        ChartCandle.dummyCandles.map { ChartPoint(date: $0.date, value: $0.close) }
    }

    private static func dummyWave(
        from base: Double,
        slope: Double,
        amplitude: Double = 3
    ) -> [ChartPoint] {
        stride(from: 0, to: 100, by: 1).map { index in
            let value = base + Double(index) * slope + sin(Double(index) / 6) * amplitude
            return ChartPoint(
                date: Date.dummyChartStart.addingTimeInterval(Double(index) * 300),
                value: value
            )
        }
    }
}
#endif
