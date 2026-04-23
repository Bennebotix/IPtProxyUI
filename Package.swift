// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IPtProxyUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "IPtProxyUI",
            targets: ["IPtProxyUI"]),
    ],
    targets: [
        .target(
            name: "IPtProxyUI",
            dependencies: [],
            path: "Sources/IPtProxyUI",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "IPtProxyUITests",
            dependencies: ["IPtProxyUI"],
            path: "Tests/IPtProxyUITests"),
    ]
)