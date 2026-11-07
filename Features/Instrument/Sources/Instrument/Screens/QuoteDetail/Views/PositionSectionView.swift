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
            SectionHeading(.init("quoteDetail.position.title", bundle: .module))

            MetricStrip(position.metrics)
        }
    }
}

#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 32) {
        PositionSectionView(position: .dummy)

        PositionSectionView(position: .dummyEuro)
    }
    .padding()
}
#endif
