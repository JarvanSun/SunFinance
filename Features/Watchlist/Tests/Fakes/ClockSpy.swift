//
//  ClockSpy.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Synchronization

final class ClockSpy: Clock {
    let now = ContinuousClock.now
    let minimumResolution = Duration.zero

    private let recordedSleeps = Mutex<[Duration]>([])

    var sleeps: [Duration] {
        recordedSleeps.withLock { $0 }
    }

    func sleep(until deadline: ContinuousClock.Instant, tolerance: Duration?) async throws {
        let duration = now.duration(to: deadline)
        recordedSleeps.withLock { $0.append(duration) }
        try Task.checkCancellation()
    }
}
