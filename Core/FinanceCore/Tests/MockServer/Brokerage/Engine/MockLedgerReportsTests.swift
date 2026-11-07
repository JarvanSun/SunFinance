//
//  MockLedgerReportsTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct MockLedgerReportsTests {
    let exchange = MockExchange()
    let date = TradingClock.tuesdayAfternoon

    @Test func accountThenAddsCashAndPositionsAndSubtractsReservedCash() throws {
        // Given
        var ledger = MockLedger.seeded(at: date, exchange: exchange)
        let draft = OrderDraft.make(.buy, .shares(1), execution: .limit(1))
        _ = ledger.place(draft, key: nil, at: date, exchange: exchange)

        // When
        let account = try Account(ledger.account(at: date, exchange: exchange))

        // Then
        let positions = ledger.positions(at: date, exchange: exchange)
        let positionsValue = positions.open.reduce(Decimal.zero) { $0 + $1.marketValue.amount }
        #expect(account.cash.amount == ledger.cash)
        #expect(account.buyingPower.amount == ledger.cash - 2)
        #expect(account.positionsValue.amount == positionsValue)
        #expect(account.total.amount == ledger.cash + positionsValue)
    }

    @Test func accountWhenAPositionWasSoldOutTodayThenTodayStillCountsIt() throws {
        // Given
        let quote = try #require(exchange.quote(for: "SAP", at: date))
        var ledger = makeLedger()
        ledger.book(.make(.buy, 10, at: 100, day: -30))
        ledger.book(.make(.sell, 10, at: 105, date: date.addingTimeInterval(-3_600)))

        // When
        let account = try Account(ledger.account(at: date, exchange: exchange))

        // Then
        #expect(account.positionsValue.amount == 0)
        #expect(account.todayGain.amount == 10 * (105 - quote.previousClose.amount))
    }

    @Test func positionsThenListsOpenByValueAndClosedApart() {
        // Given
        let ledger = MockLedger.seeded(at: date, exchange: exchange)

        // When
        let positions = ledger.positions(at: date, exchange: exchange)

        // Then
        let values = positions.open.map(\.marketValue.amount)
        #expect(values == values.sorted(by: >))
        #expect(positions.closed.map(\.symbol) == ["KO"])
        #expect(positions.closed.first?.quantity == 0)
    }

    @Test func historyThenEndsNowAtTheTotalValue() throws {
        // Given
        let ledger = MockLedger.seeded(at: date, exchange: exchange)

        // When
        let dto = ledger.history(range: .week, at: date, exchange: exchange)
        let history = try PortfolioHistory(dto)
        let account = try Account(ledger.account(at: date, exchange: exchange))

        // Then
        #expect(history.range == .week)
        #expect(history.points.last?.date == date)
        #expect(abs((history.points.last?.value.amount ?? 0) - account.total.amount) < 1)
    }

    @Test func ordersPageThenSplitsOpenFromPastNewestFirstAndPages() {
        // Given
        var ledger = MockLedger.seeded(at: date, exchange: exchange)
        let orders = (0..<25).map { index in
            ledger.place(
                .make(execution: .limit(1)),
                key: nil,
                at: date.addingTimeInterval(Double(index)),
                exchange: exchange
            )
        }
        _ = ledger.place(.make(), key: nil, at: date, exchange: exchange)

        // When
        let first = ledger.ordersPage(query(.open), at: date, exchange: exchange)
        let second = ledger.ordersPage(
            query(.open, cursor: first.nextCursor),
            at: date,
            exchange: exchange
        )
        let past = ledger.ordersPage(query(.past), at: date, exchange: exchange)

        // Then
        #expect(first.orders.count == 20)
        #expect(first.orders.first?.id == orders.last?.id)
        #expect(second.orders.count == 5)
        #expect(second.nextCursor == nil)
        #expect(past.orders.map(\.status) == ["filled"])
    }

    @Test func dtoThenDescribesTheOrderWithItsFill() throws {
        // Given
        var ledger = MockLedger.seeded(at: date, exchange: exchange)
        let draft = OrderDraft.make(.buy, .shares(2), symbol: "AAPL")
        let order = ledger.place(draft, key: nil, at: date, exchange: exchange)

        // When
        let dto = ledger.dto(of: order, at: date, exchange: exchange)

        // Then
        let fill = try #require(dto.fill)
        #expect(dto.currency == "USD")
        #expect(dto.status == "filled")
        #expect(fill.total.amount == 2 * fill.price.amount * fill.exchangeRate + 1)
    }

    @Test(arguments: [
        (
            LedgerOrder.State.working, OrderTrigger.at(.distantFuture), OrderExecution.market,
            "scheduled"
        ),
        (.working, .priceAtOrAbove(1_000), .market, "waiting_for_trigger"),
        (.working, .immediately, .limit(1), "waiting_for_price"),
        (.working, .immediately, .market, "waiting_for_open"),
        (.cancelled, .immediately, .market, "cancelled"),
        (.expired, .immediately, .market, "expired"),
        (.rejected, .immediately, .market, "rejected"),
    ])
    func dtoThenReportsTheStatusOfEachState(
        state: LedgerOrder.State,
        trigger: OrderTrigger,
        execution: OrderExecution,
        status: String
    ) {
        // Given
        let ledger = makeLedger()
        let order = LedgerOrder(
            id: "order-1",
            draft: .make(execution: execution, trigger: trigger),
            quantity: 1,
            createdAt: date,
            state: state,
            releasedAt: state == .working && trigger == .immediately ? date : nil,
            rejection: state == .rejected ? .insufficientCash : nil,
            fillID: nil
        )

        // When
        let dto = ledger.dto(of: order, at: date, exchange: exchange)

        // Then
        #expect(dto.status == status)
    }
}

private extension MockLedgerReportsTests {
    func makeLedger() -> MockLedger {
        MockLedger(
            cash: 10_000,
            orders: [],
            fills: [],
            cashEntries: [],
            idempotencyKeys: [:],
            settledUntil: date
        )
    }

    func query(_ filter: OrderListFilter, cursor: String? = nil) -> OrdersQuery {
        OrdersQuery(filter: filter, symbol: nil, cursor: cursor)
    }
}
