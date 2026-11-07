//
//  AnalyticsParameterTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Testing

@testable import FinanceCore

struct AnalyticsParameterTests {
    @Test(arguments: [
        AnalyticsParameter.query,
        .email,
        .name,
        .amount,
        .price,
        .quantity,
        .deviceID,
    ])
    func isPersonalDataWhenParameterIdentifiesAPersonThenIsTrue(parameter: AnalyticsParameter) {
        // Then
        #expect(parameter.isPersonalData)
    }

    @Test(arguments: [
        AnalyticsParameter.symbol,
        .resultCount,
        .failureReason,
        .sortOrder,
        .isFavorite,
        .appVersion,
        .locale,
        .source,
        .range,
        .chartStyle,
        .side,
        .orderType,
        .trigger,
        .status,
        .openCount,
        .positionCount,
    ])
    func isPersonalDataWhenParameterDescribesTheProductThenIsFalse(
        parameter: AnalyticsParameter
    ) {
        // Then
        #expect(!parameter.isPersonalData)
    }

    @Test(arguments: [
        (AnalyticsParameter.resultCount, "result_count"),
        (.isFavorite, "is_favorite"),
        (.deviceID, "device_id"),
        (.symbol, "symbol"),
    ])
    func rawValueThenIsSnakeCase(parameter: AnalyticsParameter, rawValue: String) {
        // Then
        #expect(parameter.rawValue == rawValue)
    }
}
