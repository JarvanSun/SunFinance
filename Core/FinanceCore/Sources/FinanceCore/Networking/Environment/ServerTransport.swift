//
//  ServerTransport.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum ServerTransport: Sendable {
    case urlSession
    case mock(MockServer)
}
