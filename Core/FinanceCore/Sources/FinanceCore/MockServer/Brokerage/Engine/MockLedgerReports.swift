//
//  MockLedgerReports.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

// MARK: - Reports

extension MockLedger {
    func account(at date: Date, exchange: MockExchange) -> AccountResponseDTO {
        let valuations = valuations(at: date, exchange: exchange).filter {
            $0.holding.isOpen || !$0.fillsToday.isEmpty
        }
        let positionsValue = valuations.reduce(Decimal.zero) { $0 + $1.marketValue }
        let todayGain = valuations.reduce(Decimal.zero) { $0 + $1.todayGain }
        return .init(
            cash: .init(euros: cash),
            buyingPower: .init(euros: buyingPower(at: date, exchange: exchange)),
            positionsValue: .init(euros: positionsValue),
            total: .init(euros: cash + positionsValue),
            todayGain: .init(euros: todayGain)
        )
    }

    func positions(at date: Date, exchange: MockExchange) -> PositionsResponseDTO {
        let valuations = valuations(at: date, exchange: exchange)
        return .init(
            open: valuations.filter(\.holding.isOpen).sorted { $0.marketValue > $1.marketValue }
                .map(\.dto),
            closed: valuations.filter { !$0.holding.isOpen }.map(\.dto)
        )
    }

    func history(range: HistoryRange, at date: Date, exchange: MockExchange)
        -> PortfolioHistoryResponseDTO
    {
        let opened = cashEntries.map(\.date).min() ?? date
        let moments = HistorySampling(range: range).moments(endingAt: date).filter { $0 >= opened }
        return PortfolioHistoryResponseDTO(
            range: range.rawValue,
            points: moments.map {
                ValuePointDTO(date: $0, value: .init(euros: totalValue(at: $0, exchange: exchange)))
            }
        )
    }

    func ordersPage(
        _ query: OrdersQuery,
        at date: Date,
        exchange: MockExchange
    ) -> OrdersResponseDTO {
        let selected =
            orders
            .filter(query.matches)
            .sorted { $0.createdAt > $1.createdAt }
        let page = page(of: selected, cursor: query.cursor)
        return .init(
            orders: page.elements.map { dto(of: $0, at: date, exchange: exchange) },
            nextCursor: page.nextCursor
        )
    }

    func dto(of order: LedgerOrder, at date: Date, exchange: MockExchange) -> OrderDTO {
        .init(
            id: order.id,
            draft: order.draft.dto,
            quantity: order.quantity,
            currency: (exchange.price(of: order.draft.symbol, at: date)?.currency ?? .eur).rawValue,
            status: statusCode(of: order, at: date, exchange: exchange).rawValue,
            rejection: order.rejection?.rawValue,
            createdAt: order.createdAt,
            fill: order.fillID.flatMap { id in fills.first { $0.id == id } }.map(\.dto)
        )
    }
}

// MARK: - Private

private extension MockLedger {
    var pageSize: Int { 20 }

    func page(of orders: [LedgerOrder], cursor: String?) -> Page<LedgerOrder> {
        let start = cursor.flatMap(Int.init) ?? 0
        let end = min(start + pageSize, orders.count)
        guard start < end else { return Page(elements: [], nextCursor: nil) }

        return .init(
            elements: Array(orders[start..<end]),
            nextCursor: end < orders.count ? String(end) : nil
        )
    }

    func statusCode(of order: LedgerOrder, at date: Date, exchange: MockExchange)
        -> OrderStatusCode
    {
        let isMarketOpen = exchange.quote(for: order.draft.symbol, at: date)?.isMarketOpen ?? false
        let draft = order.draft
        switch (order.state, order.releasedAt, draft.trigger, draft.execution, isMarketOpen) {
        case (.filled, _, _, _, _):
            return .filled
        case (.cancelled, _, _, _, _):
            return .cancelled
        case (.expired, _, _, _, _):
            return .expired
        case (.rejected, _, _, _, _):
            return .rejected
        case (.working, nil, .at, _, _):
            return .scheduled
        case (.working, nil, .priceAtOrAbove, _, _), (.working, nil, .priceAtOrBelow, _, _):
            return .waitingForTrigger
        case (.working, _, _, .limit, true):
            return .waitingForPrice
        default:
            return .waitingForOpen
        }
    }

    func valuations(at date: Date, exchange: MockExchange) -> [PositionValuation] {
        book.holdings(asOf: date).compactMap { valuation(of: $0, at: date, exchange: exchange) }
    }

    func valuation(of holding: Holding, at date: Date, exchange: MockExchange) -> PositionValuation?
    {
        guard let quote = exchange.quote(for: holding.symbol, at: date),
            let venue = exchange.venue(of: holding.symbol)
        else { return nil }

        let closes = venue.closes(atOrBefore: date)
        let previousCloseMoment =
            (quote.isMarketOpen ? closes.first : closes.dropFirst().first) ?? date
        let held = book.holding(of: holding.symbol, asOf: previousCloseMoment)?.quantity ?? 0
        return PositionValuation(
            holding: holding,
            price: quote.price.amount,
            rate: exchange.eurRate(of: quote.price.currency, at: date),
            previousClose: quote.previousClose.amount,
            previousRate: exchange.eurRate(of: quote.price.currency, at: previousCloseMoment),
            quantityAtPreviousClose: held,
            fillsToday: book.fills(of: holding.symbol, after: previousCloseMoment)
        )
    }

    func totalValue(at date: Date, exchange: MockExchange) -> Decimal {
        let cashThen = cashEntries.filter { $0.date <= date }.reduce(Decimal.zero) {
            $0 + $1.amount
        }
        let positionsValue = book.holdings(asOf: date).filter(\.isOpen).reduce(Decimal.zero) {
            sum,
            holding in
            let price = exchange.price(of: holding.symbol, at: date)
            let rate = price.map { exchange.eurRate(of: $0.currency, at: date) } ?? 0
            return sum + holding.quantity * (price?.amount ?? 0) * rate
        }
        return cashThen + positionsValue
    }
}

// MARK: - PositionValuation

private extension PositionValuation {
    var dto: PositionDTO {
        let currency = holding.currency.rawValue
        return .init(
            symbol: holding.symbol.rawValue,
            quantity: holding.quantity,
            price: MoneyDTO(amount: price, currency: currency),
            averageCost: .init(euros: holding.averageCost),
            averageLocalCost: MoneyDTO(amount: holding.averageLocalCost, currency: currency),
            costBasis: .init(euros: holding.costBasis),
            marketValue: .init(euros: marketValue),
            unrealizedGain: .init(euros: unrealizedGain),
            unrealizedGainPercent: unrealizedGainPercent,
            realizedGain: .init(euros: holding.realizedGain),
            todayGain: .init(euros: todayGain),
            currencyEffect: .init(euros: currencyEffect),
            totalReturn: .init(euros: totalReturn),
            totalReturnPercent: totalReturnPercent
        )
    }
}

// MARK: - LedgerFill

private extension LedgerFill {
    var dto: FillDTO {
        .init(
            date: date,
            quantity: quantity,
            price: MoneyDTO(amount: price, currency: currency.rawValue),
            exchangeRate: exchangeRate,
            fee: .init(euros: fee),
            total: .init(euros: total)
        )
    }
}
