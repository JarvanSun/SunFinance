//
//  MockServerBehavior.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum MockServerBehavior: Sendable {
    case realistic
    case instant
    case failingReads
    case alwaysFailing

    var latency: ClosedRange<Duration> {
        switch self {
        case .realistic:
            .milliseconds(250)...(.milliseconds(900))
        case .instant, .failingReads, .alwaysFailing:
            .zero...(.zero)
        }
    }

    var readFailureRate: Double {
        switch self {
        case .realistic:
            0.05
        case .instant:
            0
        case .failingReads, .alwaysFailing:
            1
        }
    }

    var writeFailureRate: Double {
        switch self {
        case .realistic, .instant, .failingReads:
            0
        case .alwaysFailing:
            1
        }
    }
}
