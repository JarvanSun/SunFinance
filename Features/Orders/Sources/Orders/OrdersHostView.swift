//
//  OrdersHostView.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

public struct OrdersHostView: View {
    private let dependencies: OrdersDependencies

    public init(dependencies: OrdersDependencies) {
        self.dependencies = dependencies
    }

    public var body: some View {
        OrdersNavigationHost(dependencies: dependencies)
    }
}

#if DEBUG
#Preview("Orders") {
    OrdersHostView(dependencies: PreviewObjectPool().ordersDependencies())
}
#endif
