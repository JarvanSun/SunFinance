//
//  OrderValidityPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension OrderValidity {
    var segmentTitle: LocalizedStringResource {
        switch self {
        case .day:
            .init("trading.validity.day", bundle: .module)
        case .goodTillCancelled:
            .init("trading.validity.gtc", bundle: .module)
        }
    }
}
