//
//  StatisticRow.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct StatisticRow: Identifiable, Sendable {
    let title: LocalizedStringResource
    let value: String

    var id: String {
        title.key
    }
}
