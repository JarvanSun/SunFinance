//
//  DurationExtensions.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension Duration {
    var timeInterval: TimeInterval {
        let (seconds, attoseconds) = components
        return TimeInterval(seconds) + TimeInterval(attoseconds) / attosecondsPerSecond
    }
}

private extension Duration {
    var attosecondsPerSecond: TimeInterval { 1e18 }
}
