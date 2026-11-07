//
//  OrdersPlaygroundApp.swift
//  OrdersPlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Orders
import SwiftUI

@main
struct OrdersPlaygroundApp: App {
    @State private var isReady = false

    private let brokerage = BrokerageService(
        environment: .init(mockBehavior: .realistic, storageDirectory: nil)
    )
    private let tracker = AnalyticsTracker(
        consent: UserDefaultsAnalyticsConsent(defaults: .standard),
        context: AnalyticsContext(appVersion: "playground", locale: .autoupdatingCurrent),
        destinations: [ConsoleAnalyticsDestination(subsystem: "OrdersPlayground")]
    )

    var body: some Scene {
        WindowGroup {
            if isReady {
                OrdersHostView(
                    dependencies: OrdersDependencies(
                        orderProvider: brokerage,
                        canceller: brokerage,
                        tracker: tracker,
                        quoteDetail: FeatureEntry { Text(verbatim: "Quote detail: \($0.rawValue)") }
                    )
                )
            } else {
                ProgressView()
                    .task {
                        await placeSampleOrders()
                        isReady = true
                    }
            }
        }
    }
}

private extension OrdersPlaygroundApp {
    @Sendable
    func placeSampleOrders() async {
        for draft in OrderDraft.dummyOpenOrders {
            _ = try? await brokerage.place(draft, idempotencyKey: IdempotencyKey())
        }
    }
}
