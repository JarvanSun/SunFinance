//
//  TicketPreviewState.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

enum TicketPreviewState: String, CaseIterable, CustomStringConvertible {
    case empty
    case estimated
    case tooMuch
    case stopLimitSell
    case scheduled
    case marketClosed
    case loading
    case offline
    case german

    var description: String { rawValue }

    var side: TradeSide {
        switch self {
        case .stopLimitSell: .sell
        case .empty, .estimated, .tooMuch, .scheduled, .marketClosed, .loading, .offline, .german:
            .buy
        }
    }

    var rejection: OrderRejection? {
        switch self {
        case .tooMuch: .insufficientCash
        case .empty, .estimated, .stopLimitSell, .scheduled, .marketClosed, .loading, .offline,
            .german:
            nil
        }
    }

    var failure: BrokerageError? {
        switch self {
        case .offline: .offline
        case .empty, .estimated, .tooMuch, .stopLimitSell, .scheduled, .marketClosed, .loading,
            .german:
            nil
        }
    }

    var delay: Duration {
        switch self {
        case .loading: .seconds(3_600)
        case .empty, .estimated, .tooMuch, .stopLimitSell, .scheduled, .marketClosed, .offline,
            .german:
            .zero
        }
    }

    var isMarketOpen: Bool {
        self != .marketClosed
    }

    var locale: Locale {
        switch self {
        case .german: .init(identifier: "de_DE")
        case .empty, .estimated, .tooMuch, .stopLimitSell, .scheduled, .marketClosed, .loading,
            .offline:
            Locale(identifier: "en_US")
        }
    }

    func fill(_ viewModel: TicketViewModel) {
        switch self {
        case .estimated, .marketClosed:
            viewModel.setAmountText("2")
        case .tooMuch:
            viewModel.setAmountText("200")
        case .stopLimitSell:
            viewModel.setAmountText("5")
            viewModel.selectExecution(.limit)
            viewModel.setLimitText("240")
            viewModel.selectTrigger(.price)
            viewModel.setTriggerPriceText("0")
        case .scheduled:
            viewModel.setAmountText("2")
            viewModel.selectTrigger(.time)
            viewModel.selectValidity(.goodTillCancelled)
        case .german:
            viewModel.selectAmountMode(.euros)
            viewModel.setAmountText("500,50")
            viewModel.selectExecution(.limit)
            viewModel.setLimitText("235,5")
            viewModel.selectTrigger(.time)
            viewModel.selectValidity(.goodTillCancelled)
        case .empty, .loading, .offline:
            break
        }
    }
}
#endif
