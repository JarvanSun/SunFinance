//
//  BundleDescriptionExtensions.swift
//  DesignSystem
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

extension LocalizedStringResource.BundleDescription {
    static var designSystem: Self {
        .atURL(Bundle.designSystem.bundleURL)
    }
}
