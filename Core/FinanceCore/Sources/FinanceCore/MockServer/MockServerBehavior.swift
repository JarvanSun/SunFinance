//
//  MockServerBehavior.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct MockServerBehavior: Sendable {
    let latency: ClosedRange<Duration>
    let readFailureRate: Double
    let writeFailureRate: Double

    public init(
        latency: ClosedRange<Duration>,
        readFailureRate: Double,
        writeFailureRate: Double = 0
    ) {
        self.latency = latency
        self.readFailureRate = readFailureRate
        self.writeFailureRate = writeFailureRate
    }
}

extension MockServerBehavior {
    public static let realistic = Self(
        latency: .milliseconds(250)...(.milliseconds(900)),
        readFailureRate: 0.05
    )

    public static let instant = Self(latency: .zero...(.zero), readFailureRate: 0)

    public static let alwaysFailing = Self(
        latency: .zero...(.zero),
        readFailureRate: 1,
        writeFailureRate: 1
    )
}
