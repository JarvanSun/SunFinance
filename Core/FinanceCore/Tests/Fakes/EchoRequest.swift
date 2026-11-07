//
//  EchoRequest.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore

struct EchoRequest: APIRequest {
    typealias Response = EchoDTO

    let path: [String]
    var method: HTTPMethod = .get

    var queryItems: [URLQueryItem] {
        [.init(name: "symbol", value: "AAPL")]
    }
}
