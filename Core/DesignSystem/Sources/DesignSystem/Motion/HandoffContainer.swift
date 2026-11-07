//
//  HandoffContainer.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public struct HandoffContainer<Value: Hashable, Content: View>: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dimensions) private var dimensions
    @State private var layers: [HandoffLayer<Value>] = []
    @State private var pendingValue: Value?

    private let value: Value
    private let content: (Value) -> Content

    public init(value: Value, @ViewBuilder content: @escaping (Value) -> Content) {
        self.value = value
        self.content = content
    }

    public var body: some View {
        ZStack {
            ForEach(layers) { layer in
                content(layer.value)
                    .opacity(layer.phase.opacity)
                    .scaleEffect(reduceMotion ? 1 : layer.phase.scale)
                    .offset(y: reduceMotion ? .zero : layer.phase.verticalOffset(in: dimensions))
                    .allowsHitTesting(layer.phase.isInteractive)
                    .accessibilityHidden(!layer.phase.isInteractive)
                    .transition(.identity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform: showFirst)
        .onChange(of: value) { _, newValue in handOver(to: newValue) }
    }
}

private extension HandoffContainer {
    var motion: Animation {
        FinanceMotion.reveal.animation(reduceMotion: reduceMotion) ?? .linear(duration: 0)
    }

    func showFirst() {
        layers = [HandoffLayer(value: value, phase: .shown)]
    }

    func handOver(to newValue: Value) {
        pendingValue = newValue
        withAnimation(leavingMotion) {
            for index in layers.indices {
                layers[index].phase = .leaving
            }
        } completion: {
            layers.removeAll { $0.phase == .leaving }
            guard let pendingValue, layers.isEmpty else { return }

            layers = [HandoffLayer(value: pendingValue, phase: .arriving)]
            self.pendingValue = nil
            withAnimation(motion) {
                layers[0].phase = .shown
            }
        }
    }

    var leavingMotion: Animation {
        FinanceMotion.snappy.animation(reduceMotion: reduceMotion) ?? .linear(duration: 0)
    }
}

#if DEBUG
private struct HandoffContainerPreview: View {
    @State private var isPlaced = false

    var body: some View {
        HandoffContainer(value: isPlaced) { isPlaced in
            VStack(spacing: 16) {
                Text(verbatim: isPlaced ? "Order placed" : "Review order")
                    .font(FinanceFont.largeTitle)

                Button(action: { self.isPlaced.toggle() }) {
                    Text(verbatim: "Hand over")
                }
                .buttonStyle(.finance(.primary))
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(FinanceColor.background.color)
        }
    }
}

#Preview {
    HandoffContainerPreview()
}
#endif
