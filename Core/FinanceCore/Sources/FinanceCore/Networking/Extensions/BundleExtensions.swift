//
//  BundleExtensions.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension Bundle {
    func fixture<Value: Decodable>(named name: String, as type: Value.Type) throws -> Value {
        guard let url = url(forResource: name, withExtension: jsonExtension) else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try BackendCoding().decoder.decode(type, from: Data(contentsOf: url))
    }
}

private extension Bundle {
    var jsonExtension: String { "json" }
}
