//
//  PreviewObjectPool.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import DesignSystem
import FinanceCore
import Foundation
import SwiftUI

struct PreviewObjectPool {
    func ordersDependencies() -> OrdersDependencies {
        let services = PreviewOrders()
        return .init(
            orderProvider: services,
            canceller: services,
            tracker: PreviewAnalyticsTracker(),
            quoteDetail: FeatureEntry { Text(verbatim: "Quote detail \($0.rawValue)") }
        )
    }

    func ordersViewModel(_ state: OrdersPreviewState) -> OrdersViewModel {
        let services = PreviewOrders(
            isEmpty: state.isEmpty,
            failure: state.failure,
            delay: state.delay
        )
        return .init(
            orderProvider: services,
            router: PreviewOrdersRouter(),
            tracker: PreviewAnalyticsTracker(),
            calendar: .autoupdatingCurrent,
            now: { Date() }
        )
    }

    func detailViewModel(_ order: Order) -> OrderDetailViewModel {
        .init(
            order: order,
            canceller: PreviewOrders(),
            router: PreviewOrdersRouter(),
            tracker: PreviewAnalyticsTracker()
        ) { _ in }
    }
}
#endif
