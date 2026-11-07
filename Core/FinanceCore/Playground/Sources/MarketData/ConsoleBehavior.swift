//
//  ConsoleBehavior.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum ConsoleBehavior: String, CaseIterable, Identifiable, Sendable {
    case realistic
    case instant
    case alwaysFailing

    var id: Self { self }

    var mockBehavior: MockServerBehavior {
        switch self {
        case .realistic: .realistic
        case .instant: .instant
        case .alwaysFailing: .alwaysFailing
        }
    }
}
