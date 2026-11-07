//
//  PositionActionPresentationTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation
import SwiftUI
import Testing

@testable import Portfolio

struct PositionActionPresentationTests {
    @Test(arguments: [
        (PositionAction.buyMore, "portfolio.action.buyMore", FinanceImage.buy, false),
        (.sell, "portfolio.action.sell", .sell, true),
    ])
    func presentationThenNamesTheAction(
        action: PositionAction,
        title: String,
        image: FinanceImage,
        isDestructive: Bool
    ) {
        #expect(action.title.key == title)
        #expect(action.image == image)
        #expect((action.role == .destructive) == isDestructive)
    }
}
