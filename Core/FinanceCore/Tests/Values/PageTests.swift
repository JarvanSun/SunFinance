//
//  PageTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct PageTests {
    @Test(arguments: [("next", true), (nil, false)] as [(String?, Bool)])
    func hasMoreThenFollowsNextCursor(nextCursor: String?, hasMore: Bool) {
        // Given / When
        let page = Page(elements: [1, 2], nextCursor: nextCursor)

        // Then
        #expect(page.hasMore == hasMore)
    }
}
