//
//  MockRoute.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

protocol MockRoute: Sendable {
    func response(to request: MockRequest) throws -> MockResponse?
}
