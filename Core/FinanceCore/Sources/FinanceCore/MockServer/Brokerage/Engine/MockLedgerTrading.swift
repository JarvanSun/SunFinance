//
//  MockLedgerTrading.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

// MARK: - Trading

extension MockLedger {
    mutating func settle(until date: Date, exchange: MockExchange) {
        guard date > settledUntil else { return }

        for index in orders.indices where orders[index].state == .working {
            settle(orderAt: index, until: date, exchange: exchange)
        }
        settledUntil = date
    }

    mutating func place(_ draft: OrderDraft, key: String?, at date: Date, exchange: MockExchange)
        -> LedgerOrder
    {
        switch key.flatMap({ idempotencyKeys[$0] }).flatMap(order(withID:)) {
        case .some(let existing):
            return existing
        case nil:
            let order = newOrder(for: draft, at: date, exchange: exchange)
            orders.append(order)
            key.map { idempotencyKeys[$0] = order.id }
            settle(orderAt: orders.count - 1, until: date, exchange: exchange)
            return orders[orders.count - 1]
        }
    }

    mutating func cancel(orderID: Order.ID) -> LedgerOrder? {
        guard let index = orders.firstIndex(where: { $0.id == orderID }) else { return nil }
        guard orders[index].state == .working else { return orders[index] }

        orders[index].state = .cancelled
        return orders[index]
    }

    func preview(_ draft: OrderDraft, at date: Date, exchange: MockExchange)
        -> PreviewOrderResponseDTO
    {
        let estimate = estimate(for: draft, at: date, exchange: exchange)
        let cashEffect = estimate?.cashEffect(for: draft.side) ?? 0
        return PreviewOrderResponseDTO(
            quantity: estimate?.quantity ?? 0,
            price: MoneyDTO(
                amount: estimate?.price ?? 0,
                currency: estimate?.currency.rawValue ?? CurrencyCode.eur.rawValue
            ),
            exchangeRate: estimate?.rate ?? 1,
            fee: .init(euros: fee),
            total: .init(euros: draft.side.total(ofCashEffect: cashEffect)),
            cashAfter: .init(euros: buyingPower(at: date, exchange: exchange) + cashEffect),
            rejection: rejection(for: draft, estimate: estimate, at: date, exchange: exchange)?
                .rawValue
        )
    }

    func order(withID id: Order.ID) -> LedgerOrder? {
        orders.first { $0.id == id }
    }

    func buyingPower(at date: Date, exchange: MockExchange) -> Decimal {
        cash - reservedCash(at: date, exchange: exchange)
    }

    func reservedCash(at date: Date, exchange: MockExchange) -> Decimal {
        orders
            .filter { $0.state == .working && $0.draft.side == .buy }
            .compactMap { order in
                estimate(for: order.draft, quantity: order.quantity, at: date, exchange: exchange)
            }
            .reduce(0) { $0 + $1.total(for: .buy) }
    }

    func reservedShares(of symbol: TickerSymbol) -> Decimal {
        orders
            .filter { $0.state == .working && $0.draft.side == .sell && $0.draft.symbol == symbol }
            .reduce(0) { $0 + $1.quantity }
    }
}

// MARK: - Private

private extension MockLedger {
    var day: TimeInterval { 86_400 }
    var stepLength: TimeInterval { 5 * 60 }
    var longestValidity: TimeInterval { 90 * day }
    var dayOrderHorizon: TimeInterval { 7 * day }
    var sessionsSearchedForClose: Int { 10 }
    var sessionMargin: Int { 2 }
    var quantityScale: Int { 4 }

    func newOrder(for draft: OrderDraft, at date: Date, exchange: MockExchange) -> LedgerOrder {
        let estimate = estimate(for: draft, at: date, exchange: exchange)
        let rejection = rejection(for: draft, estimate: estimate, at: date, exchange: exchange)
        return .init(
            id: UUID().uuidString,
            draft: draft,
            quantity: estimate?.quantity ?? 0,
            createdAt: date,
            state: rejection == nil ? .working : .rejected,
            releasedAt: nil,
            rejection: rejection,
            fillID: nil
        )
    }

    func estimate(
        for draft: OrderDraft,
        quantity: Decimal? = nil,
        at date: Date,
        exchange: MockExchange
    ) -> OrderEstimate? {
        guard let quote = exchange.quote(for: draft.symbol, at: date) else { return nil }

        let price = draft.estimatedPrice(marketPrice: quote.price.amount)
        let rate = exchange.eurRate(of: quote.price.currency, at: date)
        let shares =
            quantity ?? draft.quantity(at: price * rate, fee: fee, scale: quantityScale)
        return OrderEstimate(
            quantity: shares,
            price: price,
            currency: quote.price.currency,
            rate: rate,
            fee: fee
        )
    }

    func rejection(
        for draft: OrderDraft,
        estimate: OrderEstimate?,
        at date: Date,
        exchange: MockExchange
    ) -> OrderRejection? {
        guard let estimate else { return .unknownSymbol }

        return draft.validationIssue(at: date, longestValidity: longestValidity)
            ?? affordabilityIssue(for: draft, estimate: estimate, at: date, exchange: exchange)
    }

    func affordabilityIssue(
        for draft: OrderDraft,
        estimate: OrderEstimate,
        at date: Date,
        exchange: MockExchange
    ) -> OrderRejection? {
        guard estimate.quantity > 0 else { return .invalidAmount }

        switch draft.side {
        case .buy:
            let cost = estimate.total(for: .buy)
            return cost <= buyingPower(at: date, exchange: exchange) ? nil : .insufficientCash
        case .sell:
            let held = book.holding(of: draft.symbol, asOf: date)?.quantity ?? 0
            return estimate.quantity <= held - reservedShares(of: draft.symbol)
                ? nil : .insufficientShares
        }
    }

    mutating func settle(orderAt index: Int, until date: Date, exchange: MockExchange) {
        let order = orders[index]
        guard order.state == .working else { return }

        let draft = order.draft
        let expiry = expiryDate(of: order, exchange: exchange)
        let start = max(order.createdAt, settledUntil)
        let end = min(date, expiry)
        for moment in tradingMoments(of: draft.symbol, from: start, to: end, exchange: exchange) {
            guard let price = exchange.price(of: draft.symbol, at: moment)?.amount else { return }

            orders[index].releasedAt =
                orders[index].releasedAt
                ?? (draft.isTriggered(at: moment, price: price) ? moment : nil)
            guard orders[index].releasedAt != nil,
                draft.execution.allowsFill(at: price, side: draft.side)
            else { continue }

            fill(orderAt: index, at: moment, price: price, exchange: exchange)
            return
        }
        orders[index].state = date >= expiry ? .expired : .working
    }

    mutating func fill(
        orderAt index: Int,
        at moment: Date,
        price: Decimal,
        exchange: MockExchange
    ) {
        let draft = orders[index].draft
        let currency = exchange.price(of: draft.symbol, at: moment)?.currency ?? .eur
        let fill = LedgerFill(
            id: UUID().uuidString,
            orderID: orders[index].id,
            symbol: draft.symbol,
            side: draft.side,
            quantity: orders[index].quantity,
            price: price,
            currency: currency,
            exchangeRate: exchange.eurRate(of: currency, at: moment),
            fee: fee,
            date: moment
        )
        switch shortfall(of: fill) {
        case .some(let rejection):
            orders[index].state = .rejected
            orders[index].rejection = rejection
        case nil:
            book(fill)
            orders[index].state = .filled
            orders[index].fillID = fill.id
        }
    }

    func shortfall(of fill: LedgerFill) -> OrderRejection? {
        switch fill.side {
        case .buy: cash + fill.cashEffect >= 0 ? nil : .insufficientCash
        case .sell:
            (book.holding(of: fill.symbol, asOf: fill.date)?.quantity ?? 0) >= fill.quantity
                ? nil : .insufficientShares
        }
    }

    func expiryDate(of order: LedgerOrder, exchange: MockExchange) -> Date {
        switch order.draft.validity {
        case .goodTillCancelled:
            return order.createdAt.addingTimeInterval(longestValidity)
        case .day:
            let startsAt =
                order.draft.trigger.scheduledTime.map { max($0, order.createdAt) }
                ?? order.createdAt
            let horizon = startsAt.addingTimeInterval(dayOrderHorizon)
            let sessions =
                exchange.venue(of: order.draft.symbol)?
                .sessions(endingAtOrBefore: horizon, count: sessionsSearchedForClose) ?? []
            return sessions.first { $0.upperBound > startsAt }?.upperBound ?? horizon
        }
    }

    func tradingMoments(
        of symbol: TickerSymbol,
        from start: Date,
        to end: Date,
        exchange: MockExchange
    ) -> [Date] {
        guard end >= start, let venue = exchange.venue(of: symbol) else { return [] }

        let days = Int(end.timeIntervalSince(start) / day) + sessionMargin
        return venue.sessions(endingAtOrBefore: end, count: days)
            .filter { $0.upperBound >= start }
            .flatMap { session in
                stride(
                    from: max(session.lowerBound, start).timeIntervalSince1970,
                    through: session.upperBound.timeIntervalSince1970,
                    by: stepLength
                )
                .map(Date.init(timeIntervalSince1970:))
            }
            .filter { $0 >= start && $0 <= end }
    }
}
