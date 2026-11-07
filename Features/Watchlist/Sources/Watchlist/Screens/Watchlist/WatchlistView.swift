//
//  WatchlistView.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import SunUserInterface
import SwiftUI

struct WatchlistView: View {
    @Bindable var viewModel: WatchlistViewModel

    var body: some View {
        list(viewModel.content)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(FinanceColor.background.color)
            .accessibilityIdentifier(WatchlistAccessibility.list)
            .overlay(if: viewModel.placeholder) { placeholder in
                WatchlistPlaceholderView(placeholder: placeholder, onRetry: viewModel.retry)
            }
            .navigationTitle(Text("watchlist.title", bundle: .module))
            .searchable(
                text: $viewModel.searchText,
                prompt: Text("watchlist.search.prompt", bundle: .module)
            )
            .onSubmit(of: .search, viewModel.submitSearch)
            .toolbar {
                WatchlistToolbar(
                    sortOrder: viewModel.sortOrder,
                    onSelect: viewModel.selectSortOrder
                )
            }
            .refreshable { await viewModel.refresh() }
            .task(id: viewModel.quotesRequest) { await viewModel.refresh() }
            .task(id: viewModel.searchRequest) { await viewModel.searchSymbols() }
            .onAppear(perform: viewModel.trackScreenView)
    }
}

private extension WatchlistView {
    func list(_ content: WatchlistContent) -> some View {
        List(content.sections) { section in
            Section {
                switch section {
                case .quotes, .quotesMatchingSearch:
                    ForEach(content.visibleQuotes) { quote in
                        Button(action: { viewModel.openDetail(for: quote) }) {
                            QuoteRowView(
                                quote: quote,
                                favoriteAction: viewModel.favoriteAction(for: quote.symbol)
                            )
                        }
                        .buttonStyle(.finance(.row))
                        .listRowSeparator(.hidden)
                        .listRowBackground(FinanceColor.background.color)
                        .swipeActions {
                            FavoriteSwipeButton(
                                action: viewModel.favoriteAction(for: quote.symbol),
                                onToggle: { viewModel.toggleFavorite(quote.symbol) }
                            )
                        }
                        .accessibilityAction(
                            named: viewModel.favoriteAction(for: quote.symbol).title
                        ) {
                            viewModel.toggleFavorite(quote.symbol)
                        }
                    }
                case .symbolMatches:
                    ForEach(content.addableMatches) { match in
                        Button(action: { viewModel.addToWatchlist(match) }) {
                            SymbolMatchRowView(
                                match: match,
                                addition: viewModel.addition(for: match)
                            )
                        }
                        .buttonStyle(.finance(.row))
                        .disabled(!viewModel.addition(for: match).isAvailable)
                        .listRowSeparator(.hidden)
                        .listRowBackground(FinanceColor.background.color)
                        .accessibilityIdentifier(WatchlistAccessibility.addSymbolButton)
                    }
                }
            } header: {
                WatchlistSectionHeader(section: section)
            }
        }
    }
}

#if DEBUG
@available(iOS 26, *)
#Preview("Watchlist", arguments: WatchlistPreviewState.allCases) { state in
    NavigationStack {
        WatchlistView(viewModel: PreviewObjectPool().watchlistViewModel(state))
    }
    .environment(\.locale, state.locale)
}
#endif
