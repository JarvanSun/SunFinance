//
//  OrdersText.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

enum OrdersText {
    static var title: LocalizedStringResource { .init("orders.title", bundle: .module) }
    static var loading: LocalizedStringResource { .init("orders.loading", bundle: .module) }
    static var retry: LocalizedStringResource { .init("orders.failure.retry", bundle: .module) }
    static var detailTitle: LocalizedStringResource {
        .init("orders.detail.title", bundle: .module)
    }
    static var cancelOrder: LocalizedStringResource {
        .init("orders.detail.cancel", bundle: .module)
    }
    static var cancelConfirmTitle: LocalizedStringResource {
        .init("orders.detail.cancel.confirm.title", bundle: .module)
    }
    static var cancelConfirmMessage: LocalizedStringResource {
        .init("orders.detail.cancel.confirm.message", bundle: .module)
    }
    static var keepOrder: LocalizedStringResource {
        .init("orders.detail.cancel.keep", bundle: .module)
    }
    static var cancelFailed: LocalizedStringResource {
        .init("orders.detail.cancel.failed", bundle: .module)
    }
    static var viewStock: LocalizedStringResource { .init("orders.detail.stock", bundle: .module) }
    static var placedRow: LocalizedStringResource {
        .init("orders.detail.row.placed", bundle: .module)
    }
    static var typeRow: LocalizedStringResource { .init("orders.detail.row.type", bundle: .module) }
    static var triggerRow: LocalizedStringResource {
        .init("orders.detail.row.trigger", bundle: .module)
    }
    static var validityRow: LocalizedStringResource {
        .init("orders.detail.row.validity", bundle: .module)
    }
    static var quantityRow: LocalizedStringResource {
        .init("orders.detail.row.quantity", bundle: .module)
    }
    static var filledRow: LocalizedStringResource {
        .init("orders.detail.row.filled", bundle: .module)
    }
    static var priceRow: LocalizedStringResource {
        .init("orders.detail.row.price", bundle: .module)
    }
    static var rateRow: LocalizedStringResource { .init("orders.detail.row.rate", bundle: .module) }
    static var feeRow: LocalizedStringResource { .init("orders.detail.row.fee", bundle: .module) }
    static var retryPage: LocalizedStringResource {
        .init("orders.footer.retry", bundle: .module)
    }
    static var loadingMore: LocalizedStringResource {
        .init("orders.footer.loading", bundle: .module)
    }

    static func rate(currency: String, inEuros: String) -> LocalizedStringResource {
        .init("orders.detail.row.rate.value \(currency) \(inEuros)", bundle: .module)
    }
}
