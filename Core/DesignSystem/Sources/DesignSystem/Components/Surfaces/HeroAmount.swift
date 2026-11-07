//
//  HeroAmount.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import SunUserInterface
import SwiftUI

public struct HeroAmount: View {
    @Environment(\.locale) private var locale
    @Environment(\.dimensions) private var dimensions

    private let money: Money
    private let size: HeroAmountSize

    public init(_ money: Money, size: HeroAmountSize = .hero) {
        self.money = money
        self.size = size
    }

    public var body: some View {
        amount(HeroAmountParts(money, locale: locale))
            .foregroundColor(FinanceColor.textPrimary)
            .monospacedDigit()
            .lineLimit(1)
            .minimumScaleFactor(minimumScale)
            .financeNumberRoll(value: money.doubleValue)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(verbatim: money.formatted(locale: locale)))
    }
}

private extension HeroAmount {
    var minimumScale: CGFloat { 0.7 }

    var heroSymbolOffset: CGFloat {
        FinanceFont.priceLarge.uiFont.capHeight - FinanceFont.title.uiFont.capHeight
    }

    var superscriptOffset: CGFloat {
        FinanceFont.headline.uiFont.capHeight - FinanceFont.caption.uiFont.capHeight
    }

    @ViewBuilder
    func amount(_ parts: HeroAmountParts) -> some View {
        switch size {
        case .hero:
            heroAmount(parts)
        case .row:
            rowAmount(parts)
        }
    }

    func heroAmount(_ parts: HeroAmountParts) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: dimensions.heroAmountSpacing) {
            leadingSymbol(parts.leadingSymbol)

            Text(verbatim: parts.whole)
                .font(FinanceFont.priceLarge)
                .kerning(dimensions.heroAmountKerning)

            VStack(alignment: .leading, spacing: .zero) {
                Text(verbatim: parts.cents)

                Text(verbatim: parts.trailingSymbol)
            }
            .font(FinanceFont.headline)
            .alignmentGuide(.firstTextBaseline) { $0[.lastTextBaseline] }
        }
    }

    @ViewBuilder
    func leadingSymbol(_ symbol: String?) -> some View {
        switch symbol {
        case .some(let symbol):
            Text(verbatim: symbol)
                .font(FinanceFont.title)
                .baselineOffset(heroSymbolOffset)
        case nil:
            EmptyView()
        }
    }

    func rowAmount(_ parts: HeroAmountParts) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: dimensions.heroAmountRowSpacing) {
            Text(verbatim: parts.whole)
                .font(FinanceFont.headline)

            Text(verbatim: parts.cents)
                .font(FinanceFont.caption)
                .baselineOffset(superscriptOffset)
        }
    }
}

#if DEBUG
#Preview("Hero amount") {
    VStack(alignment: .leading, spacing: 24) {
        ForEach(HeroAmountSize.allCases, id: \.self) { size in
            HeroAmount(Money(22_060.20, .eur), size: size)

            HeroAmount(Money(19_848.84, .eur), size: size)
                .environment(\.locale, Locale(identifier: "de_DE"))

            HeroAmount(Money(231.42, .usd), size: size)

            HeroAmount(Money(-1_250.07, .eur), size: size)

            HeroAmount(Money(18_420, .jpy), size: size)
        }
    }
    .padding()
}
#endif
