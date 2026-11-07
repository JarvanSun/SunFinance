//
//  TicketFieldPresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import Instrument

struct TicketFieldPresentationTests {
    @Test(arguments: [
        (TicketField.amount, InstrumentAccessibility.amountField),
        (.limitPrice, .limitField),
        (.triggerPrice, .triggerPriceField),
        (.triggerTime, .triggerTimePicker),
    ])
    func accessibilityIdentifierThenNamesTheField(
        field: TicketField,
        identifier: InstrumentAccessibility
    ) {
        // Then
        #expect(field.accessibilityIdentifier == identifier)
    }
}
