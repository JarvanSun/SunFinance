//
//  PortfolioPlaceholder.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum PortfolioPlaceholder: Equatable, Sendable {
    case loading
    case empty
    case failed(PortfolioIssue)
}
