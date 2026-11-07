//
//  BrokerageServiceTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct BrokerageServiceTests {
    @Test func accountWhenSeededThenReturnsBalances() async throws {
        // Given
        let service = makeService()

        // When
        let account = try await service.account()

        // Then
        #expect(account.cash.currency == .eur)
        #expect(account.buyingPower == account.cash)
        #expect(account.total.amount == account.cash.amount + account.positionsValue.amount)
    }

    @Test func portfolioWhenSeededThenFollowsPositionMath() async throws {
        // Given
        let service = makeService()

        // When
        let portfolio = try await service.portfolio()

        // Then
        let sap = try #require(portfolio.position(of: "SAP"))
        #expect(sap.quantity == 15)
        #expect(sap.unrealizedGain.amount == sap.marketValue.amount - sap.costBasis.amount)
        #expect(sap.totalReturn.amount == sap.realizedGain.amount + sap.unrealizedGain.amount)
        #expect(portfolio.closed.first?.symbol == "KO")
    }

    @Test func portfolioHistoryWhenRequestedThenEndsAtTheAccountTotal() async throws {
        // Given
        let service = makeService()

        // When
        let history = try await service.portfolioHistory(range: .month)
        let account = try await service.account()

        // Then
        #expect(history.range == .month)
        #expect(history.points.count > 20)
        #expect(history.points.map(\.date) == history.points.map(\.date).sorted())
        #expect(abs((history.points.last?.value.amount ?? 0) - account.total.amount) < 1)
    }

    @Test func placeWhenRetriedWithSameKeyThenReturnsTheSameOrder() async throws {
        // Given
        let service = makeService()
        let key = IdempotencyKey()

        // When
        let first = try await service.place(.make(), idempotencyKey: key)
        let second = try await service.place(.make(), idempotencyKey: key)
        let past = try await service.orders(.past, symbol: nil, cursor: nil)

        // Then
        #expect(first == second)
        #expect(first.status == .filled)
        #expect(first.fill?.total.amount == (first.fill?.price.amount ?? 0) + 1)
        #expect(past.elements.map(\.id) == [first.id])
    }

    @Test func placeWhenCashIsShortThenReturnsRejectedOrder() async throws {
        // Given
        let service = makeService()

        // When
        let order = try await service.place(
            .make(.buy, .shares(1_000_000)),
            idempotencyKey: IdempotencyKey()
        )

        // Then
        #expect(order.status == .rejected(.insufficientCash))
    }

    @Test func previewWhenDraftIsValidThenEstimatesTotalAndCashAfter() async throws {
        // Given
        let service = makeService()
        let cash = try await service.account().cash

        // When
        let preview = try await service.preview(.make(.buy, .shares(2), symbol: "AAPL"))

        // Then
        #expect(preview.rejection == nil)
        #expect(preview.price.currency == .usd)
        #expect(preview.exchangeRate != 1)
        #expect(preview.cashAfter.amount == cash.amount - preview.total.amount)
    }

    @Test func cancelWhenOrderIsOpenThenMovesItToPast() async throws {
        // Given
        let service = makeService()
        let order = try await service.place(
            .make(execution: .limit(1)),
            idempotencyKey: IdempotencyKey()
        )
        let openBefore = try await service.orders(.open, symbol: nil, cursor: nil)

        // When
        let cancelled = try await service.cancel(orderID: order.id)
        let openAfter = try await service.orders(.open, symbol: nil, cursor: nil)

        // Then
        #expect(openBefore.elements.map(\.id) == [order.id])
        #expect(cancelled.status == .cancelled)
        #expect(openAfter.elements.isEmpty)
    }

    @Test func allOrdersWhenASymbolHasMoreThanOnePageThenReturnsOnlyItsOrdersFromEveryPage()
        async throws
    {
        // Given
        let service = makeService()
        for _ in 0..<21 {
            _ = try await service.place(
                .make(symbol: "AAPL", execution: .limit(1)),
                idempotencyKey: IdempotencyKey()
            )
        }
        let sap = try await service.place(
            .make(execution: .limit(1)),
            idempotencyKey: IdempotencyKey()
        )

        // When
        let firstPage = try await service.orders(.open, symbol: "AAPL", cursor: nil)
        let apple = try await service.allOrders(.open, for: "AAPL")

        // Then
        #expect(firstPage.nextCursor != nil)
        #expect(apple.count == 21)
        #expect(apple.allSatisfy { $0.draft.symbol == "AAPL" })
        #expect(!apple.map(\.id).contains(sap.id))
    }

    @Test func placeWhenServerFailsThenThrowsServerError() async {
        // Given
        let service = makeService(behavior: .alwaysFailing)

        // Then
        await #expect(throws: BrokerageError.server(statusCode: 503)) {
            try await service.place(.make(), idempotencyKey: IdempotencyKey())
        }
    }

    @Test func accountWhenServerFailsThenThrowsServerError() async {
        // Given
        let service = makeService(behavior: .alwaysFailing)

        // Then
        await #expect(throws: BrokerageError.server(statusCode: 503)) {
            try await service.account()
        }
    }
}

private extension BrokerageServiceTests {
    func makeService(behavior: MockServerBehavior = .instant) -> BrokerageService {
        let date = TradingClock.tuesdayAfternoon
        let brokerage = MockBrokerage(exchange: MockExchange(), storageURL: nil, now: date)
        let server = MockServer(
            routes: [BrokerageMockRoutes(brokerage: brokerage)],
            behavior: behavior,
            now: { date }
        )
        return BrokerageService(client: BackendClient(environment: .mock(server)))
    }
}
