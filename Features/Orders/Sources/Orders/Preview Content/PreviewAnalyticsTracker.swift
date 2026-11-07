//
//  PreviewAnalyticsTracker.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore

final class PreviewAnalyticsTracker: AnalyticsTracking {
    func track(_ event: some AnalyticsEvent) {}
}
#endif
