//
//  InstrumentAccessibility.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface

enum InstrumentAccessibility: String, AccessibilityIdentifying {
    case chart = "quoteDetail.chart"
    case rangePicker = "quoteDetail.rangePicker"
    case chartStylePicker = "quoteDetail.chartStylePicker"
    case buyButton = "quoteDetail.buyButton"
    case sellButton = "quoteDetail.sellButton"
    case quoteRetryButton = "quoteDetail.retryButton"
    case sidePicker = "trading.sidePicker"
    case amountField = "trading.amountField"
    case limitField = "trading.limitField"
    case triggerPriceField = "trading.triggerPriceField"
    case triggerTimePicker = "trading.triggerTimePicker"
    case reviewButton = "trading.reviewButton"
    case cancelButton = "trading.cancelButton"
    case slider = "trading.slider"
    case doneButton = "trading.doneButton"
    case editButton = "trading.editButton"
    case ticketRetryButton = "trading.retryButton"
}
