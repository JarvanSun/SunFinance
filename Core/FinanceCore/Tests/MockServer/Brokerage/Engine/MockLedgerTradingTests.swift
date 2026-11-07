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
        let date = Date.dummyTuesdayAfternoon
        var ledger = MockLedger(seededAt: date, exchange: exchange)
        let cashBefore = ledger.cash
        let price = try #require(exchange.price(of: "SAP", at: date)).amount

        // When
        let order = ledger.place(.dummy(.buy, .shares(2)), key: nil, at: date, exchange: exchange)

        // Then
        #expect(order.state == .filled)
        #expect(ledger.cash == cashBefore - 2 * price - 1)
        #expect(ledger.cashEntries.last?.amount == -(2 * price + 1))
    }

    @Test func placeWhenSameKeyIsSentTwiceThenPlacesOnce() {
        // Given
        let date = Date.dummyTuesdayAfternoon
        var ledger = MockLedger(seededAt: date, exchange: exchange)

        // When
        let first = ledger.place(.dummy(), key: "submit-1", at: date, exchange: exchange)
        let second = ledger.place(
            .dummy(),
            key: "submit-1",
            at: date.addingTimeInterval(1),
            exchange: exchange
        )

        // Then
        #expect(first.id == second.id)
        #expect(ledger.orders.count == 1)
    }

    @Test(arguments: [
        (OrderDraft.dummy(.buy, .shares(1_000_000)), OrderRejection.insufficientCash),
        (OrderDraft.dummy(.sell, .shares(16)), OrderRejection.insufficientShares),
        (OrderDraft.dummy(.buy, .shares(0)), OrderRejection.invalidAmount),
        (OrderDraft.dummy(execution: .limit(0)), OrderRejection.invalidPrice),
        (OrderDraft.dummy(symbol: "NOPE"), OrderRejection.unknownSymbol),
    ])
    func placeWhenDraftIsNotPossibleThenRejectsWithReason(draft: OrderDraft, reason: OrderRejection)
    {
        // Given
        let date = Date.dummyTuesdayAfternoon
        var ledger = MockLedger(seededAt: date, exchange: exchange)

        // When
        let order = ledger.place(draft, key: nil, at: date, exchange: exchange)

        // Then
        #expect(order.state == .rejected)
        #expect(order.rejection == reason)
    }

    @Test func placeWhenScheduledInThePastThenRejects() {
        // Given
        let date = Date.dummyTuesdayAfternoon
        var ledger = MockLedger(seededAt: date, exchange: exchange)

        // When
        let order = ledger.place(
            .dummy(trigger: .at(date.addingTimeInterval(-60))),
            key: nil,
            at: date,
            exchange: exchange
        )

        // Then
        #expect(order.rejection == .invalidSchedule)
    }

    @Test func settleWhenPlacedOnWeekendThenFillsAtNextOpen() throws {
        // Given
        var ledger = MockLedger(seededAt: Date.dummySaturdayNoon, exchange: exchange)
        let order = ledger.place(
            .dummy(),
            key: nil,
            at: Date.dummySaturdayNoon,
            exchange: exchange
        )
        let statusBefore = ledger.dto(
            of: order,
            at: Date.dummySaturdayNoon,
            exchange: exchange
        )
        .status

        // When
        ledger.settle(until: Date.dummyMondayMorning, exchange: exchange)

        // Then
        let settled = try #require(ledger.order(withID: order.id))
        let fill = try #require(ledger.fills.first { $0.id == settled.fillID })
        #expect(statusBefore == "waiting_for_open")
        #expect(settled.state == .filled)
        #expect(fill.date > Date.dummySaturdayNoon)
        #expect(fill.date <= Date.dummyMondayMorning)
    }

    @Test func settleWhenLimitIsNeverReachedThenDayOrderExpiresAtClose() throws {
        // Given
        let date = Date.dummyTuesdayAfternoon
        var ledger = MockLedger(seededAt: date, exchange: exchange)
        let price = try #require(exchange.price(of: "SAP", at: date)).amount
        let order = ledger.place(
            .dummy(execution: .limit(price / 2)),
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
        let date = Date.dummyTuesdayAfternoon
        let release = date.addingTimeInterval(3_600)
        var ledger = MockLedger(seededAt: date, exchange: exchange)
        let order = ledger.place(
            .dummy(trigger: .at(release)),
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
        let date = Date.dummyTuesdayAfternoon
        var ledger = MockLedger(seededAt: date, exchange: exchange)
        let price = try #require(exchange.price(of: "SAP", at: date)).amount

        // When
        let order = ledger.place(
            .dummy(trigger: .priceAtOrAbove(price * 2), validity: .goodTillCancelled),
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
        let date = Date.dummyTuesdayAfternoon
        var ledger = MockLedger(seededAt: date, exchange: exchange)
        let price = try #require(exchange.price(of: "SAP", at: date)).amount
        let powerBefore = ledger.buyingPower(at: date, exchange: exchange)

        // When
        let order = ledger.place(
            .dummy(.buy, .shares(10), execution: .limit(price / 2)),
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
        let date = Date.dummyTuesdayAfternoon
        var ledger = MockLedger(seededAt: date, exchange: exchange)
        _ = ledger.place(
            .dummy(.sell, .shares(15), trigger: .priceAtOrBelow(1)),
            key: nil,
            at: date,
            exchange: exchange
        )

        // When
        let second = ledger.place(.dummy(.sell, .shares(1)), key: nil, at: date, exchange: exchange)

        // Then
        #expect(second.rejection == .insufficientShares)
    }
}
