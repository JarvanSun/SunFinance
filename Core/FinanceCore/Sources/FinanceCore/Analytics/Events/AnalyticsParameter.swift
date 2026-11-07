//
//  AnalyticsParameter.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct AnalyticsParameter: RawRepresentable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }
}

extension AnalyticsParameter {
    public static let symbol = Self("symbol")
    public static let resultCount = Self("result_count")
    public static let failureReason = Self("failure_reason")
    public static let sortOrder = Self("sort_order")
    public static let isFavorite = Self("is_favorite")
    public static let appVersion = Self("app_version")
    public static let locale = Self("locale")
    public static let source = Self("source")
    public static let range = Self("range")
    public static let chartStyle = Self("chart_style")
    public static let side = Self("side")
    public static let orderType = Self("order_type")
    public static let trigger = Self("trigger")
    public static let status = Self("status")
    public static let openCount = Self("open_count")
    public static let positionCount = Self("position_count")

    static let personalDataKeys: Set<Self> = [
        Self("query"),
        Self("email"),
        Self("name"),
        Self("amount"),
        Self("price"),
        Self("quantity"),
        Self("device_id"),
    ]
}
