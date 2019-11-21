// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCodeHelper",
    dependencies: [
        .package(url: "https://github.com/yanagiba/swift-ast.git", from: "0.4.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftCodeHelper",
            dependencies: ["SwiftAST+Tooling"]),
        .target(name: "SwiftCodeHelperDemo",
            dependencies: ["SwiftCodeHelper"]
        ),
        .testTarget(
            name: "SwiftCodeHelperTests",
            dependencies: ["SwiftCodeHelper"]),
    ]
)
