//
//  PositionActionPresentation.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import SwiftUI

extension PositionAction {
    var title: LocalizedStringResource {
        switch self {
        case .buyMore: .init("portfolio.action.buyMore", bundle: .module)
        case .sell: .init("portfolio.action.sell", bundle: .module)
        }
    }

    var image: FinanceImage {
        switch self {
        case .buyMore: .buy
        case .sell: .sell
        }
    }

    var role: ButtonRole? {
        switch self {
        case .buyMore: nil
        case .sell: .destructive
        }
    }
}
