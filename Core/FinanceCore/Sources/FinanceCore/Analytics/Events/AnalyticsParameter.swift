//
//  AnalyticsParameter.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum AnalyticsParameter: String, Hashable, Sendable {
    case symbol
    case resultCount = "result_count"
    case failureReason = "failure_reason"
    case sortOrder = "sort_order"
    case isFavorite = "is_favorite"
    case appVersion = "app_version"
    case locale
    case source
    case range
    case chartStyle = "chart_style"
    case side
    case orderType = "order_type"
    case trigger
    case status
    case openCount = "open_count"
    case positionCount = "position_count"
    case query
    case email
    case name
    case amount
    case price
    case quantity
    case deviceID = "device_id"

    var isPersonalData: Bool {
        switch self {
        case .query, .email, .name, .amount, .price, .quantity, .deviceID: true
        case .symbol, .resultCount, .failureReason, .sortOrder, .isFavorite, .appVersion, .locale,
            .source, .range, .chartStyle, .side, .orderType, .trigger, .status, .openCount,
            .positionCount:
            false
        }
    }
}
