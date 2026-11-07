//
//  TicketIssuePresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension TicketIssue {
    func message(for field: TicketField) -> LocalizedStringResource {
        switch (self, field) {
        case (.missing, .amount):
            .init("trading.issue.amount.missing", bundle: .module)
        case (.missing, .limitPrice), (.missing, .triggerPrice), (.missing, .triggerTime):
            .init("trading.issue.price.missing", bundle: .module)
        case (.notANumber, _):
            .init("trading.issue.notANumber", bundle: .module)
        case (.notPositive, _):
            .init("trading.issue.notPositive", bundle: .module)
        case (.tooPrecise, _):
            .init("trading.issue.tooPrecise", bundle: .module)
        case (.notInFuture, _):
            .init("trading.issue.notInFuture", bundle: .module)
        case (.tooFar, _):
            .init("trading.issue.tooFar", bundle: .module)
        case (.insufficientCash, _):
            .init("trading.issue.insufficientCash", bundle: .module)
        case (.insufficientShares, _):
            .init("trading.issue.insufficientShares", bundle: .module)
        case (.belowShareStep, _):
            .init("trading.issue.belowShareStep", bundle: .module)
        case (.notTradable, _):
            .init("trading.issue.notTradable", bundle: .module)
        case (.outsideSchedule, _):
            .init("trading.issue.outsideSchedule", bundle: .module)
        }
    }
}
