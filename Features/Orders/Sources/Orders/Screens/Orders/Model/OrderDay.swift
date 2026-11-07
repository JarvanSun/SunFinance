//
//  OrderDay.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct OrderDay: Identifiable, Equatable {
    let day: Date
    let heading: OrderDayHeading
    let orders: [Order]

    var id: Date { day }
}
