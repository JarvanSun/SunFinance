//
//  TicketFieldPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

extension TicketField {
    var accessibilityIdentifier: InstrumentAccessibility {
        switch self {
        case .amount:
            .amountField
        case .limitPrice:
            .limitField
        case .triggerPrice:
            .triggerPriceField
        case .triggerTime:
            .triggerTimePicker
        }
    }
}
