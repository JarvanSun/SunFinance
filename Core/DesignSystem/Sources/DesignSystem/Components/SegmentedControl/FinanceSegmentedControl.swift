//
//  FinanceSegmentedControl.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

public struct FinanceSegmentedControl<Option: Hashable, Label: View>: View {
    @Environment(\.dimensions) private var dimensions

    private let options: [Option]
    private let selection: Option
    private let label: (Option) -> Label
    private let onSelect: (Option) -> Void
    private let style: SegmentStyle

    public init(
        options: [Option],
        selection: Option,
        style: SegmentStyle = .prominent,
        onSelect: @escaping (Option) -> Void,
        @ViewBuilder label: @escaping (Option) -> Label
    ) {
        self.options = options
        self.selection = selection
        self.onSelect = onSelect
        self.style = style
        self.label = label
    }

    public var body: some View {
        HStack(spacing: .zero) {
            ForEach(options, id: \.self) { option in
                Button(action: { onSelect(option) }) {
                    label(option)
                        .font(style.font(isSelected: option == selection))
                        .foregroundColor(style.foreground(isSelected: option == selection))
                        .monospacedDigit()
                        .frame(maxWidth: .infinity, minHeight: dimensions.minimumTapTarget)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.finance(.row))
                .accessibilityAddTraits(option == selection ? .isSelected : [])
            }
        }
        .background(alignment: .leading) { selectionCapsule }
        .padding(style.trackPadding(in: dimensions))
        .background(Capsule().fill(style.trackColor))
        .financeAnimation(.snappy, value: selection)
        .sensoryFeedback(.selection, trigger: selection)
    }
}

private extension FinanceSegmentedControl {
    var selectedIndex: Int {
        options.firstIndex(of: selection) ?? 0
    }

    var selectionCapsule: some View {
        GeometryReader { geometry in
            let width = geometry.size.width / CGFloat(max(options.count, 1))
            Capsule()
                .fill(style.capsuleColor.color)
                .frame(
                    width: style.capsuleWidth(segmentWidth: width),
                    height: style.capsuleHeight(in: dimensions)
                )
                .frame(width: width, height: geometry.size.height)
                .offset(x: width * CGFloat(selectedIndex))
        }
    }
}

#if DEBUG
private struct FinanceSegmentedControlPreview: View {
    @State private var selection = "1D"

    var body: some View {
        VStack(spacing: 24) {
            ForEach(SegmentStyle.allCases, id: \.self) { style in
                FinanceSegmentedControl(
                    options: ["1D", "1W", "1M", "3M", "1Y", "5Y"],
                    selection: selection,
                    style: style,
                    onSelect: { selection = $0 },
                    label: { Text(verbatim: $0) }
                )
            }
        }
        .padding()
    }
}

#Preview {
    FinanceSegmentedControlPreview()
}
#endif
