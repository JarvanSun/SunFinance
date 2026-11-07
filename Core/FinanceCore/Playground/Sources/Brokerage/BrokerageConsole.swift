//
//  BrokerageConsole.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Observation

@Observable
final class BrokerageConsole {
    private(set) var selectedCall: BrokerageCall?
    private(set) var output = ""

    private let service: BrokerageService

    init() {
        service = BrokerageService(
            environment: .init(mockBehavior: .realistic, storageDirectory: nil)
        )
    }

    func run(_ call: BrokerageCall) async {
        selectedCall = call
        output = "…"
        do {
            output = try await call.run(on: service)
        } catch {
            output = "Failed: \(error)"
        }
    }
}
