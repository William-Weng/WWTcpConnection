// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWTcpConnection",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWTcpConnection", targets: ["WWTcpConnection"]),
    ],
    targets: [
        .target(name: "WWTcpConnection", resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
