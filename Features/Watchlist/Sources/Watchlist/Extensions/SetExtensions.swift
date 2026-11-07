//
//  SetExtensions.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

extension Set {
    @discardableResult
    mutating func toggle(_ member: Element) -> Bool {
        guard remove(member) == nil else { return false }

        insert(member)
        return true
    }
}
