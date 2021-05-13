// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Charts",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "Charts",
            type: .dynamic,
            targets: ["Charts"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Charts"),
        .testTarget(
            name: "ChartsTests",
            dependencies: ["Charts"]),
    ]
)
