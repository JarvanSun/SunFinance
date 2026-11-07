//
//  LabeledRowValueKey.swift
//  OrdersTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

extension LabeledRowValue {
    var resourceKey: String? {
        switch self {
        case .verbatim:
            nil
        case .localized(let resource):
            resource.key
        }
    }
}
