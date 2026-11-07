//
//  FormatStyleExtensions.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension FormatStyle where Self == Date.FormatStyle {
    static var orderMoment: Date.FormatStyle {
        .dateTime.month(.abbreviated).day().hour().minute()
    }
}
