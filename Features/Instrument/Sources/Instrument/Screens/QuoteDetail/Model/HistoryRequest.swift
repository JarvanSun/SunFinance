//
//  HistoryRequest.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct HistoryRequest: Hashable, Sendable {
    let range: HistoryRange
    let reload: UUID
}
