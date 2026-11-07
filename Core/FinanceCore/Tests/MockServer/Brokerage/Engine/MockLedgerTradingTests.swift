//
//  MockLedgerTradingTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct MockLedgerTradingTests {
    let exchange = MockExchange()

    @Test func placeWhenMarketIsOpenThenFillsAtOnceAndBooksFee() throws {
        // Given
        let date = TradingClock.tuesdayAfternoon
        var ledger = MockLedger.seeded(at: date, exchange: exchange)
        let cashBefore = ledger.cash
        let price = try #require(exchange.price(of: "SAP", at: date)).amount

        // When
        let order = ledger.place(.make(.buy, .shares(2)), key: nil, at: date, exchange: exchange)

        // Then
        #expect(order.state == .filled)
        #expect(ledger.cash == cashBefore - 2 * price - 1)
        #expect(ledger.cashEntries.last?.amount == -(2 * price + 1))
    }

    @Test func placeWhenSameKeyIsSentTwiceThenPlacesOnce() {
        // Given
        let date = TradingClock.tuesdayAfternoon
        var ledger = MockLedger.seeded(at: date, exchange: exchange)

        // When
        let first = ledger.place(.make(), key: "submit-1", at: date, exchange: exchange)
        let second = ledger.place(
            .make(),
            key: "submit-1",
            at: date.addingTimeInterval(1),
            exchange: exchange
        )

        // Then
        #expect(first.id == second.id)
        #expect(ledger.orders.count == 1)
    }

    @Test(arguments: [
        (OrderDraft.make(.buy, .shares(1_000_000)), OrderRejection.insufficientCash),
        (OrderDraft.make(.sell, .shares(16)), OrderRejection.insufficientShares),
        (OrderDraft.make(.buy, .shares(0)), OrderRejection.invalidAmount),
        (OrderDraft.make(execution: .limit(0)), OrderRejection.invalidPrice),
        (OrderDraft.make(symbol: "NOPE"), OrderRejection.unknownSymbol),
    ])
    func placeWhenDraftIsNotPossibleThenRejectsWithReason(draft: OrderDraft, reason: OrderRejection)
    {
        // Given
        let date = TradingClock.tuesdayAfternoon
        var ledger = MockLedger.seeded(at: date, exchange: exchange)

        // When
        let order = ledger.place(draft, key: nil, at: date, exchange: exchange)

        // Then
        #expect(order.state == .rejected)
        #expect(order.rejection == reason)
    }

    @Test func placeWhenScheduledInThePastThenRejects() {
        // Given
        let date = TradingClock.tuesdayAfternoon
        var ledger = MockLedger.seeded(at: date, exchange: exchange)

        // When
        let order = ledger.place(
            .make(trigger: .at(date.addingTimeInterval(-60))),
            key: nil,
            at: date,
            exchange: exchange
        )

        // Then
        #expect(order.rejection == .invalidSchedule)
    }

    @Test func settleWhenPlacedOnWeekendThenFillsAtNextOpen() throws {
        // Given
        var ledger = MockLedger.seeded(at: TradingClock.saturdayNoon, exchange: exchange)
        let order = ledger.place(
            .make(),
            key: nil,
            at: TradingClock.saturdayNoon,
            exchange: exchange
        )
        let statusBefore = ledger.dto(of: order, at: TradingClock.saturdayNoon, exchange: exchange)
            .status

        // When
        ledger.settle(until: TradingClock.mondayMorning, exchange: exchange)

        // Then
        let settled = try #require(ledger.order(withID: order.id))
        let fill = try #require(ledger.fills.first { $0.id == settled.fillID })
        #expect(statusBefore == "waiting_for_open")
        #expect(settled.state == .filled)
        #expect(fill.date > TradingClock.saturdayNoon)
        #expect(fill.date <= TradingClock.mondayMorning)
    }

    @Test func settleWhenLimitIsNeverReachedThenDayOrderExpiresAtClose() throws {
        // Given
        let date = TradingClock.tuesdayAfternoon
        var ledger = MockLedger.seeded(at: date, exchange: exchange)
        let price = try #require(exchange.price(of: "SAP", at: date)).amount
        let order = ledger.place(
            .make(execution: .limit(price / 2)),
            key: nil,
            at: date,
            exchange: exchange
        )

        // When
        ledger.settle(until: date.addingTimeInterval(24 * 3_600), exchange: exchange)

        // Then
        #expect(order.state == .working)
        #expect(ledger.order(withID: order.id)?.state == .expired)
    }

    @Test func settleWhenScheduledTimeComesThenFillsAtThatMoment() throws {
        // Given
        let date = TradingClock.tuesdayAfternoon
        let release = date.addingTimeInterval(3_600)
        var ledger = MockLedger.seeded(at: date, exchange: exchange)
        let order = ledger.place(
            .make(trigger: .at(release)),
            key: nil,
            at: date,
            exchange: exchange
        )
        let statusBefore = ledger.dto(of: order, at: date, exchange: exchange).status

        // When
        ledger.settle(until: release.addingTimeInterval(600), exchange: exchange)

        // Then
        let fill = try #require(ledger.fills.first { $0.orderID == order.id })
        #expect(statusBefore == "scheduled")
        #expect(fill.date >= release)
        #expect(fill.price == exchange.price(of: "SAP", at: fill.date)?.amount)
    }

    @Test func settleWhenStopIsNotReachedThenWaitsForTrigger() throws {
        // Given
        let date = TradingClock.tuesdayAfternoon
        var ledger = MockLedger.seeded(at: date, exchange: exchange)
        let price = try #require(exchange.price(of: "SAP", at: date)).amount

        // When
        let order = ledger.place(
            .make(trigger: .priceAtOrAbove(price * 2), validity: .goodTillCancelled),
            key: nil,
            at: date,
            exchange: exchange
        )
        ledger.settle(until: date.addingTimeInterval(3 * 86_400), exchange: exchange)

        // Then
        #expect(ledger.order(withID: order.id)?.state == .working)
        #expect(ledger.dto(of: order, at: date, exchange: exchange).status == "waiting_for_trigger")
    }

    @Test func placeWhenBuyLimitIsOpenThenReservesBuyingPowerUntilCancelled() throws {
        // Given
        let date = TradingClock.tuesdayAfternoon
        var ledger = MockLedger.seeded(at: date, exchange: exchange)
        let price = try #require(exchange.price(of: "SAP", at: date)).amount
        let powerBefore = ledger.buyingPower(at: date, exchange: exchange)

        // When
        let order = ledger.place(
            .make(.buy, .shares(10), execution: .limit(price / 2)),
            key: nil,
            at: date,
            exchange: exchange
        )
        let powerWhileOpen = ledger.buyingPower(at: date, exchange: exchange)
        let cancelled = ledger.cancel(orderID: order.id)

        // Then
        #expect(powerWhileOpen < powerBefore)
        #expect(cancelled?.state == .cancelled)
        #expect(ledger.buyingPower(at: date, exchange: exchange) == powerBefore)
    }

    @Test func placeWhenSellIsOpenThenItsSharesCannotBeSoldTwice() {
        // Given
        let date = TradingClock.tuesdayAfternoon
        var ledger = MockLedger.seeded(at: date, exchange: exchange)
        _ = ledger.place(
            .make(.sell, .shares(15), trigger: .priceAtOrBelow(1)),
            key: nil,
            at: date,
            exchange: exchange
        )

        // When
        let second = ledger.place(.make(.sell, .shares(1)), key: nil, at: date, exchange: exchange)

        // Then
        #expect(second.rejection == .insufficientShares)
    }
}
