//
//  ViewExtensions.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

extension View {
    public func overlay<Value, Content: View>(
        if value: Value?,
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping (Value) -> Content
    ) -> some View {
        overlay(alignment: alignment) {
            switch value {
            case .some(let value):
                content(value)
            case nil:
                EmptyView()
            }
        }
    }

    public func safeAreaInset<Value, Content: View>(
        edge: VerticalEdge,
        if value: Value?,
        @ViewBuilder content: @escaping (Value) -> Content
    ) -> some View {
        safeAreaInset(edge: edge) {
            switch value {
            case .some(let value):
                content(value)
            case nil:
                EmptyView()
            }
        }
    }
}
