//
//  ConsoleAnalyticsDestination.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import OSLog

@MainActor
public final class ConsoleAnalyticsDestination: AnalyticsDestination {
    private enum LogCategory: String {
        case analytics = "Analytics"
    }

    private let logger: Logger

    public init(subsystem: String) {
        logger = Logger(subsystem: subsystem, category: LogCategory.analytics.rawValue)
    }

    public func send(_ event: TrackedEvent) {
        logger.debug("\(event.name.rawValue, privacy: .public) \(event.parameters.description)")
    }

    public func applyConsent(_ isGranted: Bool) {
        logger.debug("consent \(isGranted)")
    }
}
#endif
