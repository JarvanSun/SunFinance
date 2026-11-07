//
//  OrderRejectionPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension OrderRejection {
    var message: LocalizedStringResource {
        switch self {
        case .insufficientCash: .init("trading.rejection.insufficientCash", bundle: .module)
        case .insufficientShares: .init("trading.rejection.insufficientShares", bundle: .module)
        case .invalidAmount: .init("trading.rejection.invalidAmount", bundle: .module)
        case .invalidPrice: .init("trading.rejection.invalidPrice", bundle: .module)
        case .invalidSchedule: .init("trading.rejection.invalidSchedule", bundle: .module)
        case .unknownSymbol: .init("trading.rejection.unknownSymbol", bundle: .module)
        }
    }
}
