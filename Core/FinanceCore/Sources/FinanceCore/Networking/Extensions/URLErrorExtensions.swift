//
//  URLErrorExtensions.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension URLError {
    var isConnectivityFailure: Bool {
        connectivityCodes.contains(code)
    }
}

private extension URLError {
    var connectivityCodes: Set<Code> {
        [
            .notConnectedToInternet,
            .networkConnectionLost,
            .timedOut,
            .cannotConnectToHost,
            .dataNotAllowed,
        ]
    }
}
