// swift-tools-version: 6.2
//
//  Package.swift
//  Orders
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
    name: "Orders",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "Orders", targets: ["Orders"])
    ],
    dependencies: [
        .package(url: "https://github.com/JarvanSun/SunKit.git", .upToNextMinor(from: "0.2.2")),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/FinanceCore"),
    ],
    targets: [
        .target(
            name: "Orders",
            dependencies: [
                "DesignSystem",
                "FinanceCore",
                .product(name: "SunUserInterface", package: "SunKit"),
            ],
            resources: [.process("Resources")],
            swiftSettings: mainActorByDefault
        ),
        .testTarget(
            name: "OrdersTests",
            dependencies: ["Orders"],
            path: "Tests",
            swiftSettings: mainActorByDefault
        ),
    ],
    swiftLanguageModes: [.v6]
)
