//
//  QuoteDetailPlaceholderPresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import Instrument

struct QuoteDetailPlaceholderPresentationTests {
    @Test(arguments: [
        (QuoteDetailPlaceholder.loading, "quoteDetail.placeholder.loading"),
        (.failed(.offline), "quoteDetail.placeholder.offline.title"),
        (.failed(.serviceUnavailable), "quoteDetail.placeholder.unavailable.title"),
    ])
    func titleThenNamesThePlaceholder(placeholder: QuoteDetailPlaceholder, key: String) {
        // Then
        #expect(placeholder.title.key == key)
    }
}
