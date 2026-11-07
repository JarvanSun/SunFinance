//
//  StatisticRowPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem

extension StatisticRow {
    var metric: Metric {
        .init(id: id, label: title, value: value)
    }
}
