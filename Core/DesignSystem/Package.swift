// swift-tools-version: 6.2
//
//  Package.swift
//  DesignSystem
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
    name: "DesignSystem",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"])
    ],
    dependencies: [
        .package(url: "https://github.com/JarvanSun/SunKit.git", .upToNextMinor(from: "0.2.2")),
        .package(path: "../FinanceCore"),
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                "FinanceCore",
                .product(name: "SunUserInterface", package: "SunKit"),
            ],
            resources: [.process("Resources")],
            swiftSettings: mainActorByDefault
        ),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"],
            path: "Tests",
            swiftSettings: mainActorByDefault
        ),
    ],
    swiftLanguageModes: [.v6]
)
