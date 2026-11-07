//
//  TradingSnapshotCharting.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension TradingSnapshot {
    func chartLayer(for history: PriceHistory) -> ChartTradingLayer {
        ChartTradingLayer(markers: markers(within: history), levels: levels)
    }
}

private extension TradingSnapshot {
    func markers(within history: PriceHistory) -> [ChartMarker] {
        guard let start = history.candles.first?.start else { return [] }

        return orders.compactMap { order in
            guard let fill = order.fill, fill.date >= start else { return nil }

            return ChartMarker(
                date: fill.date,
                value: fill.price.doubleValue,
                kind: order.markerKind
            )
        }
    }

    var levels: [ChartLevel] {
        orders.filter(\.status.isOpen).flatMap { $0.limitLevels + $0.triggerLevels }
    }
}

private extension Order {
    var markerKind: ChartMarker.Kind {
        switch draft.side {
        case .buy:
            .buy
        case .sell:
            .sell
        }
    }

    var limitLevels: [ChartLevel] {
        switch draft.execution {
        case .limit(let price):
            [level(.limit, at: price, label: .init("quoteDetail.level.limit", bundle: .module))]
        case .market:
            []
        }
    }

    var triggerLevels: [ChartLevel] {
        switch draft.trigger {
        case .priceAtOrAbove(let price), .priceAtOrBelow(let price):
            [level(.trigger, at: price, label: .init("quoteDetail.level.trigger", bundle: .module))]
        case .immediately, .at:
            []
        }
    }

    func level(
        _ kind: LevelKind,
        at price: Decimal,
        label: LocalizedStringResource
    ) -> ChartLevel {
        ChartLevel(
            id: "\(id).\(kind.rawValue)",
            value: Money(price, currency).doubleValue,
            label: label
        )
    }
}

private enum LevelKind: String {
    case limit
    case trigger
}
