//
//  OrderRejectionPresentation.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension OrderRejection {
    var message: LocalizedStringResource {
        switch self {
        case .insufficientCash: .init("orders.rejection.insufficientCash", bundle: .module)
        case .insufficientShares: .init("orders.rejection.insufficientShares", bundle: .module)
        case .invalidAmount: .init("orders.rejection.invalidAmount", bundle: .module)
        case .invalidPrice: .init("orders.rejection.invalidPrice", bundle: .module)
        case .invalidSchedule: .init("orders.rejection.invalidSchedule", bundle: .module)
        case .unknownSymbol: .init("orders.rejection.unknownSymbol", bundle: .module)
        }
    }
}
