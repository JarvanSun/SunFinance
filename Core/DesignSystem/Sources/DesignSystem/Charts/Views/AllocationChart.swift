//
//  AllocationChart.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Charts
import SunUserInterface
import SwiftUI

public struct AllocationChart<Center: View>: View {
    @Environment(\.dimensions) private var dimensions
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedAngle: Double?
    @State private var sweep: Double = 0

    private let content: AllocationChartContent
    private let selection: AllocationSlice.ID?
    private let onSelect: (AllocationSlice.ID?) -> Void
    private let center: (AllocationSlice?) -> Center

    public init(
        _ content: AllocationChartContent,
        selection: AllocationSlice.ID?,
        onSelect: @escaping (AllocationSlice.ID?) -> Void,
        @ViewBuilder center: @escaping (AllocationSlice?) -> Center
    ) {
        self.content = content
        self.selection = selection
        self.onSelect = onSelect
        self.center = center
    }

    public var body: some View {
        Chart {
            ForEach(slices) { slice in
                SectorMark(
                    angle: .value(PlotKey.value.rawValue, slice.value),
                    innerRadius: .ratio(innerRatio),
                    outerRadius: .ratio(outerRatio(of: slice)),
                    angularInset: dimensions.chartSliceGap
                )
                .cornerRadius(dimensions.cornerRadiusSmall)
                .foregroundStyle(palette.color(of: slice))
                .opacity(opacity(of: slice))
            }

            SectorMark(
                angle: .value(PlotKey.value.rawValue, unswept),
                innerRadius: .ratio(innerRatio)
            )
            .foregroundStyle(.clear)
        }
        .chartLegend(.hidden)
        .chartAngleSelection(value: $selectedAngle)
        .chartBackground { proxy in
            GeometryReader { geometry in
                Color.clear
                    .overlay(if: proxy.plotFrame.map { geometry[$0] }) { frame in
                        center(selectedSlice)
                            .frame(width: frame.width * innerRatio * centerShare)
                            .position(x: frame.midX, y: frame.midY)
                    }
            }
        }
        .frame(height: dimensions.chartHeight)
        .financeAnimation(.settle, value: selection)
        .sensoryFeedback(.selection, trigger: selection)
        .onChange(of: selectedAngle) { _, angle in
            guard let angle else { return }

            onSelect(slice(atCumulative: angle)?.id)
        }
        .onAppear(perform: sweepIn)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityChartDescriptor(
            AllocationChartDescriptor(slices: slices, accessibility: content.accessibility)
        )
    }
}

// MARK: - Private

private extension AllocationChart {
    var innerRatio: Double { 0.64 }

    var restingOuterRatio: Double { 0.92 }

    var centerShare: Double { 0.8 }

    var initialShare: Double { 0.02 }

    var slices: [AllocationSlice] {
        content.slices
    }

    var palette: AllocationPalette {
        .init(slices: slices)
    }

    var total: Double {
        slices.reduce(0) { $0 + $1.value }
    }

    var shownShare: Double {
        initialShare + (1 - initialShare) * sweep
    }

    var unswept: Double {
        total * (1 / shownShare - 1)
    }

    var selectedSlice: AllocationSlice? {
        slices.first { $0.id == selection }
    }

    var accessibilityLabel: Text {
        switch content.accessibility {
        case .some(let accessibility): .init(accessibility.summary)
        case nil: .init(verbatim: "")
        }
    }

    func outerRatio(of slice: AllocationSlice) -> Double {
        slice.id == selection ? 1 : restingOuterRatio
    }

    func opacity(of slice: AllocationSlice) -> Double {
        switch selection {
        case .some(let selection): slice.id == selection ? 1 : FinanceOpacity.dimmed.value
        case nil: 1
        }
    }

    func slice(atCumulative angle: Double) -> AllocationSlice? {
        var running = 0.0
        return slices.first { slice in
            running += slice.value
            return angle <= running
        }
    }

    func sweepIn() {
        guard sweep == 0 else { return }

        withAnimation(FinanceMotion.draw.animation(reduceMotion: reduceMotion)) {
            sweep = 1
        }
    }
}

// MARK: - Previews

#if DEBUG
private struct AllocationChartPreview: View {
    @State private var selection: AllocationSlice.ID?
    @State private var replay = 0

    var body: some View {
        VStack(spacing: 24) {
            AllocationChart(
                .dummy,
                selection: selection,
                onSelect: { selection = $0 }
            ) { slice in
                Text(verbatim: slice?.label ?? "Total")
                    .textStyle(FinanceColor.textPrimary, FinanceFont.headline)
            }
            .id(replay)

            AllocationChart(
                AllocationChartContent(slices: [AllocationSlice.dummyAllocation[0]]),
                selection: nil,
                onSelect: { _ in }
            ) { _ in
                Text(verbatim: "One holding")
                    .textStyle(FinanceColor.textSecondary, FinanceFont.caption)
            }

            Button(action: { replay += 1 }) {
                Text(verbatim: "Replay")
            }
            .buttonStyle(.finance(.secondary))
        }
        .padding()
    }
}

#Preview("Allocation Chart") {
    AllocationChartPreview()
}
#endif
