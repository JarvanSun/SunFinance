//
//  VendorLoggedEvent.swift
//  VendorAnalyticsSDK
//
//  Created by Jiawen Sun on 2026/11/07.
//

public struct VendorLoggedEvent: Equatable, Sendable {
    public let name: String
    public let parameterNames: Set<String>

    public init(name: String, parameterNames: Set<String>) {
        self.name = name
        self.parameterNames = parameterNames
    }
}
