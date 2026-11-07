//
//  ReviewView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct ReviewView: View {
    @Environment(\.dimensions) private var dimensions
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showsResult = false
    @State private var reloadRequest = 0

    let viewModel: ReviewViewModel

    var body: some View {
        HandoffContainer(value: showsResult) { showsResult in
            switch (showsResult, viewModel.outcome) {
            case (true, .some(let outcome)):
                OrderResultView(
                    outcome: outcome,
                    draft: viewModel.draft,
                    currency: viewModel.currency,
                    onDone: viewModel.finish,
                    onEdit: viewModel.editOrder
                )
            case (false, _), (true, nil):
                reviewContent
            }
        }
        .background(FinanceColor.background.color)
        .navigationTitle(Text(TradingText.reviewTitle))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(hidesBackButton)
        .interactiveDismissDisabled(!viewModel.canGoBack)
        .task(id: reloadRequest) { await viewModel.loadPreview() }
        .task(id: viewModel.placementRequest) { await viewModel.placeRequestedOrder() }
        .task(id: viewModel.outcome) { await revealResult() }
    }
}

// MARK: - Sections

private extension ReviewView {
    var reviewContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: dimensions.spaceXLarge) {
                Text(viewModel.draft.headline)
                    .textStyle(FinanceColor.textPrimary, FinanceFont.title)
                    .accessibilityAddTraits(.isHeader)

                LabeledRows(viewModel.draft.termRows(currency: viewModel.currency))

                previewSection
            }
            .padding(dimensions.spaceLargeSmall)
            .frame(maxWidth: dimensions.formMaximumWidth)
            .frame(maxWidth: .infinity)
        }
        .floatingBottomBar { confirmBar }
    }

    @ViewBuilder
    var previewSection: some View {
        switch viewModel.preview {
        case .idle, .loading:
            LoadingStateView(title: TradingText.loading)
                .frame(maxWidth: .infinity, minHeight: dimensions.placeholderMinimumHeight)
        case .failed(let issue):
            ContentUnavailableStateView(
                title: issue.title,
                message: issue.message,
                image: issue.image,
                action: StateAction(title: TradingText.retry, perform: requestReload)
            )
            .accessibilityIdentifier(InstrumentAccessibility.ticketRetryButton)
        case .loaded(let preview):
            VStack(alignment: .leading, spacing: dimensions.spaceMedium) {
                LabeledRows(preview.rows(side: viewModel.draft.side))

                previewNote(preview.rejection)
            }
            .transition(.identity)
        }
    }

    @ViewBuilder
    func previewNote(_ rejection: OrderRejection?) -> some View {
        switch rejection {
        case .some(let rejection):
            Label {
                Text(rejection.message)
            } icon: {
                Image(style: FinanceImage.warning)
            }
            .textStyle(FinanceColor.critical, FinanceFont.callout)
        case nil:
            Text(TradingText.reviewNote)
                .textStyle(FinanceColor.textSecondary, FinanceFont.caption)
        }
    }

    var confirmBar: some View {
        VStack(spacing: dimensions.spaceSmall) {
            RevealContainer(isRevealed: viewModel.placement.isFailed) {
                Text(viewModel.placement.failureMessage)
                    .textStyle(FinanceColor.critical, FinanceFont.caption)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }

            switch viewModel.predictedRejection {
            case .some:
                Button(action: viewModel.editOrder) {
                    Text(TradingText.editOrder)
                }
                .buttonStyle(.finance(.primary))
                .accessibilityIdentifier(InstrumentAccessibility.editButton)
            case nil:
                SlideToConfirm(
                    viewModel.draft.side.slideTitle,
                    phase: viewModel.placement.slidePhase,
                    onConfirm: viewModel.confirm
                )
                .disabled(!viewModel.isSliderEnabled)
                .accessibilityIdentifier(InstrumentAccessibility.slider)
            }
        }
        .padding(.horizontal, dimensions.spaceLargeSmall)
        .padding(.vertical, dimensions.spaceMedium)
    }
}

// MARK: - Private

private extension ReviewView {
    var resultDelay: Duration { .milliseconds(650) }

    var hidesBackButton: Bool {
        !viewModel.canGoBack || showsResult
    }

    func requestReload() {
        reloadRequest += 1
    }

    func revealResult() async {
        guard viewModel.outcome != nil else { return }

        if !reduceMotion {
            try? await Task.sleep(for: resultDelay)
        }
        showsResult = true
    }
}

// MARK: - Previews

#if DEBUG
@available(iOS 26, *)
#Preview("Review", arguments: ReviewPreviewState.allCases) { state in
    NavigationStack {
        ReviewView(viewModel: PreviewObjectPool.reviewViewModel(state))
    }
    .environment(\.locale, state.locale)
}
#endif
