//
//  FinanceButtonKindTests.swift
//  DesignSystemTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import DesignSystem

struct FinanceButtonKindTests {
    @Test(arguments: [
        (FinanceButtonKind.primary, FinanceColor.textOnAccent),
        (.secondary, .accent),
        (.tertiary, .accent),
        (.destructive, .textOnAccent),
        (.row, .textPrimary),
    ])
    func foregroundThenContrastsWithTheFill(kind: FinanceButtonKind, expected: FinanceColor) {
        // When
        let foreground = kind.foreground

        // Then
        #expect(foreground == expected)
    }

    @Test(arguments: [
        (FinanceButtonKind.primary, false, FinanceColor?.some(.accent)),
        (.primary, true, .accent),
        (.secondary, false, nil),
        (.secondary, true, nil),
        (.tertiary, false, nil),
        (.tertiary, true, nil),
        (.destructive, false, .critical),
        (.destructive, true, .critical),
        (.row, false, nil),
        (.row, true, .surfaceElevated),
    ])
    func fillThenOnlyRowChangesWhilePressed(
        kind: FinanceButtonKind,
        isPressed: Bool,
        expected: FinanceColor?
    ) {
        // When
        let fill = kind.fill(isPressed: isPressed)

        // Then
        #expect(fill == expected)
    }

    @Test(arguments: [
        (FinanceButtonKind.primary, FinanceColor?.none),
        (.secondary, .accent),
        (.tertiary, nil),
        (.destructive, nil),
        (.row, nil),
    ])
    func borderThenOnlySecondaryIsOutlined(kind: FinanceButtonKind, expected: FinanceColor?) {
        // When
        let border = kind.border

        // Then
        #expect(border == expected)
    }

    @Test(arguments: [
        (FinanceButtonKind.primary, FinanceFont.headline),
        (.secondary, .headline),
        (.tertiary, .callout),
        (.destructive, .headline),
        (.row, .body),
    ])
    func fontThenFollowsEmphasis(kind: FinanceButtonKind, expected: FinanceFont) {
        // When
        let font = kind.font

        // Then
        #expect(font == expected)
    }

    @Test(arguments: [
        (FinanceButtonKind.primary, true, true, true),
        (.secondary, true, true, true),
        (.tertiary, false, true, true),
        (.destructive, true, true, true),
        (.row, true, false, false),
    ])
    func layoutThenRowHasNoChromeOfItsOwn(
        kind: FinanceButtonKind,
        fillsWidth: Bool,
        hasPadding: Bool,
        dimsWhenPressed: Bool
    ) {
        // Then
        #expect(kind.fillsWidth == fillsWidth)
        #expect(kind.hasPadding == hasPadding)
        #expect(kind.dimsWhenPressed == dimsWhenPressed)
    }
}
