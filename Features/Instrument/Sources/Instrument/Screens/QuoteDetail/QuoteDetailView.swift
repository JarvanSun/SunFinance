//
//  QuoteDetailView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import SunUserInterface
import SwiftUI

struct QuoteDetailView: View {
    @Environment(\.dimensions) private var dimensions

    let viewModel: QuoteDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: dimensions.spaceXXLarge) {
                PriceChartSection(
                    history: viewModel.history.shown,
                    trading: viewModel.tradingSnapshot,
                    companyName: viewModel.companyName,
                    style: viewModel.chartStyle,
                    range: viewModel.range,
                    canShowCandles: viewModel.canShowCandles,
                    onScrub: viewModel.scrub(to:),
                    onSelectRange: viewModel.selectRange,
                    onSelectStyle: viewModel.selectChartStyle
                )

                KeyStatisticsView(rows: viewModel.statisticRows)
            }
            .safeAreaInset(edge: .top, if: viewModel.header) { header in
                QuoteHeaderView(header: header)
                    .padding(.bottom, dimensions.spaceXXLarge)
            }
            .safeAreaInset(edge: .bottom, if: viewModel.position) { position in
                PositionSectionView(position: position)
                    .padding(.top, dimensions.spaceXXLarge)
            }
            .padding(dimensions.spaceLargeSmall)
        }
        .background(FinanceColor.background.color)
        .floatingBottomBar {
            TradeActionsView(actions: viewModel.tradeActions, onTrade: viewModel.openTicket)
        }
        .overlay(if: viewModel.placeholder) { placeholder in
            QuoteDetailPlaceholderView(placeholder: placeholder, onRetry: viewModel.retry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(FinanceColor.background.color)
        }
        .navigationTitle(Text(verbatim: viewModel.title))
        .navigationBarTitleDisplayMode(.inline)
        .refreshable { await viewModel.refresh() }
        .task(id: viewModel.reloadRequest) { await viewModel.reload() }
        .task(id: viewModel.historyRequest) { await viewModel.loadHistory() }
        .onAppear(perform: viewModel.trackScreenView)
    }
}

#if DEBUG
@available(iOS 26, *)
#Preview("Quote Detail", arguments: QuoteDetailPreviewState.allCases) { state in
    NavigationStack {
        QuoteDetailView(viewModel: PreviewObjectPool.quoteDetailViewModel(state))
    }
    .environment(\.locale, state.locale)
}
#endif
