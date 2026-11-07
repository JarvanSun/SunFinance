//
//  TicketView.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct TicketView: View {
    @Environment(\.dimensions) private var dimensions
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var reloadRequest = 0

    let viewModel: TicketViewModel

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                switch viewModel.context {
                case .loaded(let context):
                    form(context)
                case .idle, .loading, .failed:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: viewModel.firstIssueField) { _, field in
                scroll(proxy, to: field)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .floatingBottomBar {
            EstimateBar(
                side: viewModel.form.side,
                estimate: viewModel.estimate,
                onReview: viewModel.review
            )
        }
        .background(FinanceColor.background.color)
        .overlay(if: viewModel.placeholder) { placeholder in
            TicketPlaceholderView(placeholder: placeholder, onRetry: requestReload)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(FinanceColor.background.color)
        }
        .navigationTitle(Text(viewModel.title))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: viewModel.cancel) {
                    Text("trading.cancel", bundle: .module)
                }
                .accessibilityIdentifier(InstrumentAccessibility.cancelButton)
            }
        }
        .task(id: reloadRequest) { await viewModel.load() }
        .task(id: viewModel.draft) { await viewModel.refreshEstimate() }
        .onAppear(perform: viewModel.trackScreenView)
    }
}

// MARK: - Sections

private extension TicketView {
    func form(_ context: TicketContext) -> some View {
        VStack(alignment: .leading, spacing: dimensions.spaceXLarge) {
            TicketHeaderView(context: context, side: viewModel.form.side)

            RevealContainer(isRevealed: viewModel.offersSideChoice) {
                sidePicker
            }

            amountSection

            executionSection

            triggerSection

            validitySection
        }
        .padding(dimensions.spaceLargeSmall)
        .frame(maxWidth: dimensions.formMaximumWidth)
        .frame(maxWidth: .infinity)
    }

    var sidePicker: some View {
        FinanceSegmentedControl(
            options: viewModel.sides,
            selection: viewModel.form.side,
            onSelect: viewModel.selectSide
        ) {
            Text($0.segmentTitle)
        }
        .accessibilityIdentifier(InstrumentAccessibility.sidePicker)
    }

    var amountSection: some View {
        VStack(alignment: .leading, spacing: dimensions.spaceSmall) {
            FinanceSegmentedControl(
                options: AmountMode.allCases,
                selection: viewModel.form.amountMode,
                onSelect: viewModel.selectAmountMode
            ) {
                Text($0.segmentTitle)
            }

            DecimalFieldRow(
                field: .amount,
                title: viewModel.form.amountMode.fieldTitle,
                text: binding(\.amountText, set: viewModel.setAmountText),
                issue: viewModel.issue(for: .amount),
                shakeCount: viewModel.blockedReviewCount
            )

            RevealContainer(isRevealed: viewModel.offersSellAll) {
                Button(action: viewModel.sellAll) {
                    Text("trading.amount.sellAll", bundle: .module)
                }
                .buttonStyle(.finance(.tertiary))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var executionSection: some View {
        TicketSection(title: .init("trading.execution.title", bundle: .module)) {
            FinanceSegmentedControl(
                options: ExecutionKind.allCases,
                selection: viewModel.form.execution,
                onSelect: viewModel.selectExecution
            ) {
                Text($0.segmentTitle)
            }

            RevealContainer(isRevealed: viewModel.form.hasLimit) {
                DecimalFieldRow(
                    field: .limitPrice,
                    title: viewModel.form.side.limitFieldTitle,
                    text: binding(\.limitText, set: viewModel.setLimitText),
                    issue: viewModel.issue(for: .limitPrice),
                    shakeCount: viewModel.blockedReviewCount
                )
                .padding(.top, dimensions.spaceSmall)
            }
        }
    }

    var triggerSection: some View {
        TicketSection(title: .init("trading.trigger.title", bundle: .module)) {
            FinanceSegmentedControl(
                options: TriggerKind.allCases,
                selection: viewModel.form.trigger,
                onSelect: viewModel.selectTrigger
            ) {
                Text($0.segmentTitle)
            }

            RevealContainer(isRevealed: viewModel.form.hasTriggerPrice) {
                DecimalFieldRow(
                    field: .triggerPrice,
                    title: viewModel.form.side.triggerPriceFieldTitle,
                    text: binding(\.triggerPriceText, set: viewModel.setTriggerPriceText),
                    issue: viewModel.issue(for: .triggerPrice),
                    shakeCount: viewModel.blockedReviewCount
                )
                .padding(.top, dimensions.spaceSmall)
            }

            RevealContainer(isRevealed: viewModel.form.hasTriggerTime) {
                triggerTimeRow
                    .padding(.top, dimensions.spaceSmall)
            }
        }
    }

    var triggerTimeRow: some View {
        VStack(alignment: .leading, spacing: 0) {
            DatePicker(
                selection: binding(\.triggerDate, set: viewModel.setTriggerDate),
                in: viewModel.triggerDateRange,
                displayedComponents: [.date, .hourAndMinute]
            ) {
                Text("trading.trigger.time.field", bundle: .module)
                    .textStyle(FinanceColor.textPrimary, FinanceFont.callout)
            }
            .tint(FinanceColor.accent.color)
            .accessibilityIdentifier(TicketField.triggerTime.accessibilityIdentifier)

            FieldIssueView(
                field: .triggerTime,
                issue: viewModel.issue(for: .triggerTime),
                shakeCount: viewModel.blockedReviewCount
            )
        }
        .id(TicketField.triggerTime)
    }

    var validitySection: some View {
        RevealContainer(isRevealed: viewModel.form.offersValidity) {
            TicketSection(title: .init("trading.validity.title", bundle: .module)) {
                FinanceSegmentedControl(
                    options: OrderValidity.allCases,
                    selection: viewModel.form.validity,
                    onSelect: viewModel.selectValidity
                ) {
                    Text($0.segmentTitle)
                }
            }
        }
    }
}

// MARK: - Private

private extension TicketView {
    func binding<Value>(
        _ keyPath: KeyPath<TicketForm, Value>,
        set: @escaping @MainActor @Sendable (Value) -> Void
    ) -> Binding<Value> {
        .init(get: { viewModel.form[keyPath: keyPath] }, set: set)
    }

    func scroll(_ proxy: ScrollViewProxy, to field: TicketField?) {
        guard let field else { return }

        withAnimation(FinanceMotion.reveal.animation(reduceMotion: reduceMotion)) {
            proxy.scrollTo(field, anchor: .center)
        }
    }

    func requestReload() {
        reloadRequest += 1
    }
}

// MARK: - Previews

#if DEBUG
@available(iOS 26, *)
#Preview("Ticket", arguments: TicketPreviewState.allCases) { state in
    NavigationStack {
        TicketView(viewModel: PreviewObjectPool().ticketViewModel(state))
    }
    .environment(\.locale, state.locale)
}
#endif
