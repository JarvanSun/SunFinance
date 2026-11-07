//
//  StringExtensions.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

extension String {
    public var isBlank: Bool {
        allSatisfy(\.isWhitespace)
    }
}
