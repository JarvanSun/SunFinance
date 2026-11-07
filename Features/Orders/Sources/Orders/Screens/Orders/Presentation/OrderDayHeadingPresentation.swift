//
//  OrderDayHeadingPresentation.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension OrderDayHeading {
    var title: LocalizedStringResource {
        switch self {
        case .today: .init("orders.day.today", bundle: .module)
        case .yesterday: .init("orders.day.yesterday", bundle: .module)
        case .date(let day): .init("orders.day.date \(day.formatted(dayFormat))", bundle: .module)
        }
    }
}

private extension OrderDayHeading {
    var dayFormat: Date.FormatStyle {
        .dateTime.weekday(.abbreviated).day().month(.abbreviated)
    }
}
