// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Autograph",
    platforms: [.iOS(SupportedPlatform.IOSVersion.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Autograph",
            targets: ["Autograph"]),
    ],
    dependencies: [
        // temporary until in repo
        .package(path: "https://github.com/jensmoes/swift-ui-helpers")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Autograph",
            dependencies: ["SwiftUIHelpers"]),
        .testTarget(
            name: "AutographTests",
            dependencies: ["Autograph"]),
    ]
)
