//
//  PortfolioView.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct PortfolioView: View {
    @Environment(\.dimensions) private var dimensions
    @State private var reloadRequest = 0

    let viewModel: PortfolioViewModel

    var body: some View {
        ScrollView {
            switch viewModel.snapshot {
            case .loaded(let snapshot):
                content(snapshot)
            case .idle, .loading, .failed:
                EmptyView()
            }
        }
        .background(FinanceColor.background.color)
        .overlay(if: viewModel.placeholder) { placeholder in
            PortfolioPlaceholderView(placeholder: placeholder, onRetry: requestReload)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(FinanceColor.background.color)
        }
        .navigationTitle(Text(PortfolioText.title))
        .refreshable { await viewModel.refresh() }
        .task(id: reloadRequest) {
            await viewModel.load()
            await viewModel.keepFresh()
        }
        .task(id: viewModel.range) { await viewModel.loadHistory() }
        .onAppear(perform: viewModel.trackScreenView)
    }
}

// MARK: - Private

private extension PortfolioView {
    func content(_ snapshot: PortfolioSnapshot) -> some View {
        VStack(alignment: .leading, spacing: dimensions.spaceXXLarge) {
            VStack(alignment: .leading, spacing: dimensions.spaceXLarge) {
                PortfolioHeaderView(header: viewModel.header(of: snapshot))
                    .padding(.horizontal, dimensions.spaceLargeSmall)

                ValueChartSection(
                    history: viewModel.history.shown,
                    ranges: viewModel.ranges,
                    range: viewModel.range,
                    isLive: viewModel.isLive,
                    onScrub: viewModel.scrub(to:),
                    onSelectRange: viewModel.selectRange
                )
            }

            MetricStrip(snapshot.metrics)
                .padding(.horizontal, dimensions.spaceLargeSmall)
                .padding(.top, -dimensions.spaceSmall)

            allocationSection(snapshot.allocation)

            positionsSection(snapshot.allocation)

            RevealContainer(isRevealed: viewModel.hasClosedPositions) {
                closedSection
            }
        }
        .padding(.bottom, dimensions.spaceXXLarge)
    }

    func allocationSection(_ allocation: PortfolioAllocation) -> some View {
        VStack(alignment: .leading, spacing: dimensions.spaceMedium) {
            SectionHeading(PortfolioText.allocationTitle)

            SurfaceGroup {
                AllocationSection(
                    allocation: allocation,
                    selection: viewModel.selectedSymbol,
                    onSelect: viewModel.selectSlice
                )
            }
        }
        .padding(.horizontal, dimensions.spaceLargeSmall)
    }

    func positionsSection(_ allocation: PortfolioAllocation) -> some View {
        VStack(alignment: .leading, spacing: dimensions.spaceMedium) {
            SectionHeading(PortfolioText.positionsTitle)

            VStack(spacing: 0) {
                switch viewModel.positionsPlaceholder {
                case .some(let placeholder):
                    PortfolioPlaceholderView(placeholder: placeholder, onRetry: requestReload)
                        .padding(dimensions.spaceLargeSmall)
                case nil:
                    EmptyView()
                }

                ForEach(viewModel.openPositions) { position in
                    Button {
                        viewModel.openPosition(position.symbol)
                    } label: {
                        PositionRowView(
                            position: position,
                            swatch: allocation.swatch(for: position.symbol),
                            highlight: allocation.highlight(
                                for: position.symbol,
                                selection: viewModel.selectedSymbol
                            )
                        )
                    }
                    .buttonStyle(.finance(.row))
                    .accessibilityIdentifier(PortfolioAccessibility.positionRow)
                    .contextMenu {
                        PositionActionsMenu { viewModel.perform($0, on: position.symbol) }
                    }
                }
            }
        }
        .padding(.horizontal, dimensions.spaceLargeSmall)
    }

    var closedSection: some View {
        VStack(alignment: .leading, spacing: dimensions.spaceMedium) {
            SectionHeading(PortfolioText.closedTitle)

            VStack(spacing: 0) {
                ForEach(viewModel.closedPositions) { position in
                    ClosedPositionRowView(position: position)
                }
            }
        }
        .padding(.horizontal, dimensions.spaceLargeSmall)
    }

    func requestReload() {
        reloadRequest += 1
    }
}

// MARK: - Previews

#if DEBUG
@available(iOS 26, *)
#Preview("Portfolio", arguments: PortfolioPreviewState.allCases) { state in
    NavigationStack {
        PortfolioView(viewModel: PreviewObjectPool.portfolioViewModel(state))
    }
    .environment(\.locale, state.locale)
}
#endif
