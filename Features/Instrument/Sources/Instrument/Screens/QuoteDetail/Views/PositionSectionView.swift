//
//  PositionSectionView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct PositionSectionView: View {
    @Environment(\.dimensions) private var dimensions

    let position: Position

    var body: some View {
        VStack(alignment: .leading, spacing: dimensions.spaceLargeSmall) {
            SectionHeading(QuoteDetailText.positionTitle)

            MetricStrip(position.metrics)
        }
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 32) {
        PositionSectionView(position: PreviewObjectPool.position)

        PositionSectionView(position: PreviewObjectPool.euroPosition)
    }
    .padding()
}
#endif
