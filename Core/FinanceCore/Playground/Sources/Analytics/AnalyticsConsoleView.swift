//
//  AnalyticsConsoleView.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct AnalyticsConsoleView: View {
    let console: AnalyticsConsole

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: consentSelection) {
                        Text(verbatim: "Consent granted")
                    }
                    .tint(FinanceColor.accent.color)
                }

                Section {
                    ForEach(PlaygroundEvent.allCases) { event in
                        Button(action: { console.send(event) }) {
                            Text(verbatim: event.name.rawValue)
                        }
                        .buttonStyle(.finance(.secondary))
                    }
                } header: {
                    Text(verbatim: "Send (\(console.sentCount) sent)")
                }

                Section {
                    ForEach(console.receivedEvents.indices, id: \.self) { index in
                        ReceivedEventLine(event: console.receivedEvents[index])
                    }
                } header: {
                    Text(verbatim: "Received by destinations (\(console.receivedEvents.count))")
                }
            }
            .navigationTitle(Text(verbatim: "Analytics"))
        }
    }
}

private extension AnalyticsConsoleView {
    var consentSelection: Binding<Bool> {
        .init(get: { console.isConsentGranted }, set: { console.setConsent($0) })
    }
}

private struct ReceivedEventLine: View {
    let event: TrackedEvent

    var body: some View {
        VStack(alignment: .leading) {
            Text(verbatim: event.name.rawValue)
                .textStyle(FinanceColor.textPrimary, FinanceFont.headline)

            Text(verbatim: parameterSummary)
                .textStyle(FinanceColor.textSecondary, FinanceFont.caption)
        }
    }

    private var parameterSummary: String {
        event.parameters
            .map { "\($0.key.rawValue)=\($0.value)" }
            .sorted()
            .joined(separator: " ")
    }
}

#if DEBUG
#Preview {
    AnalyticsConsoleView(console: AnalyticsConsole())
}
#endif
