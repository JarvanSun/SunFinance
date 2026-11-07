//
//  PortfolioFreshness.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum PortfolioFreshness: Equatable {
    case live
    case stale(PortfolioIssue)
}
