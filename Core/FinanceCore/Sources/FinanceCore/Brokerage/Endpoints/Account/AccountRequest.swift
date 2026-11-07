//
//  AccountRequest.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore

struct AccountRequest: APIRequest {
    typealias Response = AccountResponseDTO

    var path: [String] { BrokerageEndpoint.account.path }

    var method: HTTPMethod { BrokerageEndpoint.account.method }
}
