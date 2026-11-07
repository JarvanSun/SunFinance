//
//  FinanceFont.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunUserInterface
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

public enum FinanceFont: CaseIterable, FontStyling {
    case largeTitle
    case title
    case headline
    case body
    case callout
    case caption
    case priceLarge
    case figure

    public var size: CGFloat { style.size }

    public var lineHeight: CGFloat { style.lineHeight }

    public var nativeLineHeight: CGFloat { style.nativeLineHeight }

    public var relativeTo: Font.TextStyle {
        switch self {
        case .largeTitle, .priceLarge:
            .largeTitle
        case .title:
            .title2
        case .figure:
            .title3
        case .headline:
            .headline
        case .body:
            .body
        case .callout:
            .callout
        case .caption:
            .caption
        }
    }

    public var font: Font { style.font }

    #if canImport(UIKit)
    public var uiFont: UIFont { style.uiFont }
    #endif
}

extension FinanceFont {
    var face: InterFace {
        switch self {
        case .largeTitle:
            .bold
        case .priceLarge, .title:
            .semiBold
        case .headline, .figure:
            .medium
        case .body, .callout, .caption:
            .regular
        }
    }

    var pointSize: CGFloat {
        switch self {
        case .largeTitle:
            32
        case .priceLarge:
            38
        case .title:
            20
        case .figure:
            19
        case .headline:
            16
        case .body:
            16
        case .callout:
            14
        case .caption:
            12
        }
    }
}

private extension FinanceFont {
    var style: FontStyle {
        FontRegistrar().registerBundledFonts()
        return FontStyle(
            face.postScriptName,
            size: pointSize,
            weight: face.weight,
            relativeTo: relativeTo
        )
    }
}

#if DEBUG
#Preview("Fonts") {
    VStack(alignment: .leading, spacing: 12) {
        ForEach(FinanceFont.allCases, id: \.self) { font in
            Text(verbatim: "\(font) 1,234.56")
                .textStyle(FinanceColor.textPrimary, font)
        }
    }
    .padding()
}
#endif
