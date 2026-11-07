//
//  BrokerageConsoleView.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SwiftUI

struct BrokerageConsoleView: View {
    let console: BrokerageConsole

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(BrokerageCall.allCases) { call in
                        Button {
                            Task { await console.run(call) }
                        } label: {
                            Text(verbatim: call.title)
                        }
                    }
                }
                Section {
                    Text(verbatim: console.output)
                        .font(.footnote.monospaced())
                        .textSelection(.enabled)
                } header: {
                    Text(verbatim: console.selectedCall?.title ?? "Output")
                }
            }
            .navigationTitle(Text(verbatim: "Brokerage"))
        }
    }
}
