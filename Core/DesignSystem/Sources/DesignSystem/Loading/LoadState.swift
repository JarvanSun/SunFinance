//
//  LoadState.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum LoadState<Value: Equatable, Issue: Equatable>: Equatable {
    case idle
    case loading
    case loaded(Value)
    case failed(Issue)

    public var value: Value? {
        switch self {
        case .loaded(let value): value
        case .idle, .loading, .failed: nil
        }
    }

    public var reloading: Self {
        switch self {
        case .loaded: self
        case .idle, .loading, .failed: .loading
        }
    }

    public func settled(with result: Self) -> Self {
        switch (self, result) {
        case (.loaded, .failed): self
        default: result
        }
    }
}

extension LoadState: Sendable where Value: Sendable, Issue: Sendable {}
