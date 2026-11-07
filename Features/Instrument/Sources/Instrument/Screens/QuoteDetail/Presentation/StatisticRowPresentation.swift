//
//  StatisticRowPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem

extension StatisticRow {
    var metric: Metric {
        Metric(id: id, label: title, value: value)
    }
}
