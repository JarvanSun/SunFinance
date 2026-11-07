//
//  OrderValidityPresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct OrderValidityPresentationTests {
    @Test(arguments: [
        (OrderValidity.day, "trading.validity.day"),
        (.goodTillCancelled, "trading.validity.gtc"),
    ])
    func segmentTitleThenNamesTheValidity(validity: OrderValidity, key: String) {
        // Then
        #expect(validity.segmentTitle.key == key)
    }
}
