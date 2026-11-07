//
//  OrderStatusNoteView.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct OrderStatusNoteView: View {
    let note: OrderStatusNote

    var body: some View {
        switch note {
        case .none:
            EmptyView()
        case .waiting(let text):
            waiting(text)
        case .rejected(let text):
            rejected(text)
        }
    }
}

private extension OrderStatusNoteView {
    func waiting(_ text: LocalizedStringResource) -> some View {
        Text(text)
            .textStyle(FinanceColor.textSecondary, FinanceFont.callout)
    }

    func rejected(_ text: LocalizedStringResource) -> some View {
        Label {
            Text(text)
        } icon: {
            Image(style: FinanceImage.warning)
        }
        .textStyle(FinanceColor.critical, FinanceFont.callout)
    }
}

#if DEBUG
#Preview {
    VStack(alignment: .leading, spacing: 16) {
        OrderStatusNoteView(note: OrderStatusNote(.waitingForPrice))

        OrderStatusNoteView(note: OrderStatusNote(.rejected(.insufficientCash)))
    }
    .padding()
}
#endif
