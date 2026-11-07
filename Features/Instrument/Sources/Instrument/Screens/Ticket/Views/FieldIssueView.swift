//
//  FieldIssueView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct FieldIssueView: View {
    @Environment(\.dimensions) private var dimensions
    @State private var shownIssue = TicketIssue.missing

    let field: TicketField
    let issue: TicketIssue?
    let shakeCount: Int

    var body: some View {
        RevealContainer(isRevealed: isShown) {
            Label {
                Text(shownIssue.message(for: field))
            } icon: {
                Image(style: FinanceImage.warning)
            }
            .textStyle(FinanceColor.critical, FinanceFont.caption)
            .padding(.top, dimensions.spaceXSmall)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .financeShake(count: shakes)
        .onChange(of: issue, initial: true) { _, issue in
            keep(issue)
        }
    }
}

private extension FieldIssueView {
    var isShown: Bool {
        issue != nil
    }

    var shakes: Int {
        switch isShown {
        case true:
            shakeCount
        case false:
            0
        }
    }

    func keep(_ issue: TicketIssue?) {
        guard let issue else { return }

        shownIssue = issue
    }
}
