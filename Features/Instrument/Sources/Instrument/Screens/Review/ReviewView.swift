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
                result(outcome)
            case (false, _), (true, nil):
                reviewContent
            }
        }
        .background(FinanceColor.background.color)
        .navigationTitle(Text("trading.review.title", bundle: .module))
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
    func result(_ outcome: OrderOutcome) -> some View {
        OrderResultView(
            outcome: outcome,
            draft: viewModel.draft,
            currency: viewModel.currency,
            onDone: viewModel.finish,
            onEdit: viewModel.editOrder
        )
    }

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
            previewLoading
        case .failed(let issue):
            previewFailure(issue)
        case .loaded(let preview):
            loadedPreview(preview)
        }
    }

    var previewLoading: some View {
        LoadingStateView(title: .init("trading.loading", bundle: .module))
            .frame(maxWidth: .infinity, minHeight: dimensions.placeholderMinimumHeight)
    }

    func previewFailure(_ issue: TradingIssue) -> some View {
        ContentUnavailableStateView(
            title: issue.title,
            message: issue.message,
            image: issue.image,
            action: StateAction(
                title: .init("trading.failure.retry", bundle: .module),
                perform: requestReload
            )
        )
        .accessibilityIdentifier(InstrumentAccessibility.ticketRetryButton)
    }

    func loadedPreview(_ preview: OrderPreview) -> some View {
        VStack(alignment: .leading, spacing: dimensions.spaceMedium) {
            LabeledRows(preview.rows(side: viewModel.draft.side))

            previewNote(preview.rejection)
        }
        .transition(.identity)
    }

    @ViewBuilder
    func previewNote(_ rejection: OrderRejection?) -> some View {
        switch rejection {
        case .some(let rejection):
            rejectionNote(rejection)
        case nil:
            reviewNote
        }
    }

    func rejectionNote(_ rejection: OrderRejection) -> some View {
        Label {
            Text(rejection.message)
        } icon: {
            Image(style: FinanceImage.warning)
        }
        .textStyle(FinanceColor.critical, FinanceFont.callout)
    }

    var reviewNote: some View {
        Text("trading.review.note", bundle: .module)
            .textStyle(FinanceColor.textSecondary, FinanceFont.caption)
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
                editButton
            case nil:
                confirmSlider
            }
        }
        .padding(.horizontal, dimensions.spaceLargeSmall)
        .padding(.vertical, dimensions.spaceMedium)
    }

    var editButton: some View {
        Button(action: viewModel.editOrder) {
            Text("trading.review.edit", bundle: .module)
        }
        .buttonStyle(.finance(.primary))
        .accessibilityIdentifier(InstrumentAccessibility.editButton)
    }

    var confirmSlider: some View {
        SlideToConfirm(
            viewModel.draft.side.slideTitle,
            phase: viewModel.placement.slidePhase,
            onConfirm: viewModel.confirm
        )
        .disabled(!viewModel.isSliderEnabled)
        .accessibilityIdentifier(InstrumentAccessibility.slider)
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
        ReviewView(viewModel: PreviewObjectPool().reviewViewModel(state))
    }
    .environment(\.locale, state.locale)
}
#endif
