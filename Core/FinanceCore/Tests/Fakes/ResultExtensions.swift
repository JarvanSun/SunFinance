//
//  ResultExtensions.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

extension Result {
    var failure: Failure? {
        guard case .failure(let error) = self else { return nil }

        return error
    }
}
