//
//  TicketForm.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct TicketForm: Equatable, Sendable {
    var side: TradeSide
    var amountMode = AmountMode.shares
    var amountText = ""
    var execution = ExecutionKind.market
    var limitText = ""
    var trigger = TriggerKind.now
    var triggerPriceText = ""
    var triggerDate: Date
    var validity = OrderValidity.day

    var offersValidity: Bool {
        execution == .limit || trigger != .now
    }

    var hasLimit: Bool {
        execution == .limit
    }

    var hasTriggerPrice: Bool {
        trigger == .price
    }

    var hasTriggerTime: Bool {
        trigger == .time
    }

    func issues(input: DecimalInput, now: Date) -> [TicketField: TicketIssue] {
        var issues = [TicketField: TicketIssue]()
        issues[.amount] = amountIssue(input: input)
        if execution == .limit {
            issues[.limitPrice] = priceIssue(limitText, input: input)
        }
        switch trigger {
        case .now:
            break
        case .price:
            issues[.triggerPrice] = priceIssue(triggerPriceText, input: input)
        case .time:
            issues[.triggerTime] = timeIssue(now: now)
        }
        return issues
    }

    func scheduleRange(from now: Date) -> ClosedRange<Date> {
        now...now.addingTimeInterval(longestSchedule)
    }

    func draft(symbol: TickerSymbol, input: DecimalInput, now: Date) -> OrderDraft? {
        guard issues(input: input, now: now).isEmpty, let amount = input.parse(amountText) else {
            return nil
        }

        return OrderDraft(
            symbol: symbol,
            side: side,
            amount: amountMode == .shares ? .shares(amount) : .euros(amount),
            execution: orderExecution(input: input),
            trigger: orderTrigger(input: input),
            validity: offersValidity ? validity : .day
        )
    }
}

private extension TicketForm {
    var quantityScale: Int { 4 }

    var longestSchedule: TimeInterval { 90 * 86_400 }

    func amountIssue(input: DecimalInput) -> TicketIssue? {
        guard !amountText.isBlank else { return .missing }
        guard let amount = input.parse(amountText) else { return .notANumber }
        guard amount > 0 else { return .notPositive }

        let isTooPrecise = amountMode == .shares && amount.decimalPlaces > quantityScale
        return isTooPrecise ? .tooPrecise : nil
    }

    func priceIssue(_ text: String, input: DecimalInput) -> TicketIssue? {
        guard !text.isBlank else { return .missing }
        guard let price = input.parse(text) else { return .notANumber }

        return price > 0 ? nil : .notPositive
    }

    func timeIssue(now: Date) -> TicketIssue? {
        switch triggerDate {
        case ...now: .notInFuture
        case now.addingTimeInterval(longestSchedule)...: .tooFar
        default: nil
        }
    }

    func orderExecution(input: DecimalInput) -> OrderExecution {
        switch (execution, input.parse(limitText)) {
        case (.limit, .some(let price)): .limit(price)
        case (.limit, nil), (.market, _): .market
        }
    }

    func orderTrigger(input: DecimalInput) -> OrderTrigger {
        switch (trigger, input.parse(triggerPriceText), side) {
        case (.price, .some(let price), .buy): .priceAtOrAbove(price)
        case (.price, .some(let price), .sell): .priceAtOrBelow(price)
        case (.time, _, _): .at(triggerDate)
        case (.now, _, _), (.price, nil, _): .immediately
        }
    }
}

private extension Decimal {
    var decimalPlaces: Int {
        max(-exponent, 0)
    }
}
