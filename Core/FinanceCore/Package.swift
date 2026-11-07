// swift-tools-version: 6.2
//
//  Package.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import PackageDescription

let mainActorByDefault: [SwiftSetting] = [
    .defaultIsolation(MainActor.self),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("MemberImportVisibility"),
]

let package = Package(
    name: "FinanceCore",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "FinanceCore", targets: ["FinanceCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/JarvanSun/SunKit.git", .upToNextMinor(from: "0.2.2"))
    ],
    targets: [
        .target(
            name: "FinanceCore",
            dependencies: [
                "VendorAnalyticsSDK",
                .product(name: "SunCore", package: "SunKit"),
            ],
            resources: [.process("Resources")],
            swiftSettings: [.enableUpcomingFeature("MemberImportVisibility")]
        ),
        .target(name: "VendorAnalyticsSDK", swiftSettings: mainActorByDefault),
        .testTarget(
            name: "FinanceCoreTests",
            dependencies: ["FinanceCore", "VendorAnalyticsSDK"],
            path: "Tests",
            swiftSettings: [.enableUpcomingFeature("MemberImportVisibility")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
