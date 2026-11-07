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
        let drafts = [
            OrderDraft(
                symbol: "AAPL",
                side: .buy,
                amount: .shares(3),
                execution: .limit(1),
                trigger: .immediately,
                validity: .goodTillCancelled
            ),
            OrderDraft(
                symbol: "SAP",
                side: .sell,
                amount: .shares(5),
                execution: .market,
                trigger: .priceAtOrBelow(1),
                validity: .goodTillCancelled
            ),
            OrderDraft(
                symbol: "NVDA",
                side: .buy,
                amount: .euros(500),
                execution: .market,
                trigger: .at(.now.addingTimeInterval(86_400)),
                validity: .day
            ),
        ]
        for draft in drafts {
            _ = try? await brokerage.place(draft, idempotencyKey: IdempotencyKey())
        }
    }
}
