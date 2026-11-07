//
//  RangedHistory.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct RangedHistory<Range: Hashable, Value: Equatable, Issue: Equatable>: Equatable {
    public private(set) var range: Range
    public private(set) var shown: LoadState<Value, Issue> = .idle

    public var selected: Value? {
        switch shownRange {
        case .some(let shownRange) where shownRange == range: shown.value
        case .some, nil: nil
        }
    }

    private var shownRange: Range?
    private var cache: [Range: Value] = [:]

    public init(range: Range) {
        self.range = range
    }

    public mutating func select(_ newRange: Range) {
        range = newRange
        switch cache[newRange] {
        case .some(let cached):
            show(cached, of: newRange)
        case nil:
            shown = shown.reloading
        }
    }

    public mutating func startLoading() {
        shown = shown.reloading
    }

    public mutating func settle(with result: LoadState<Value, Issue>, for requested: Range) {
        switch (result, requested == range) {
        case (.loaded(let fetched), true):
            cache[requested] = fetched
            show(fetched, of: requested)
        case (.loaded(let fetched), false):
            cache[requested] = fetched
        case (.failed, true) where shownRange == requested:
            break
        case (.failed(let issue), true):
            shown = .failed(issue)
            shownRange = nil
        case (.failed, false), (.idle, _), (.loading, _):
            break
        }
    }
}

private extension RangedHistory {
    mutating func show(_ value: Value, of range: Range) {
        shown = .loaded(value)
        shownRange = range
    }
}

extension RangedHistory: Sendable where Range: Sendable, Value: Sendable, Issue: Sendable {}
