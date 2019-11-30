// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCodeHelper",
    dependencies: [
        .package(url: "https://github.com/yanagiba/swift-ast.git", from: "0.4.2"),
        .package(url: "https://github.com/kevinvandenbreemen/swift-commandlinekit.git", .branch("forPullRequests")),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0"),
        .package(url: "https://github.com/kevinvandenbreemen/Cacao.git", .branch("develop")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "DisplayLogic", path: "./Sources/cDisplayLogic"),
        .target(
            name: "SwiftCodeHelper",
            dependencies: ["SwiftAST+Tooling", "CommandLineKit", "Logging", "Cacao", "DisplayLogic"]),
        .target(name: "SwiftCodeHelperDemo",
            dependencies: ["SwiftCodeHelper"]
        ),
        .testTarget(
            name: "SwiftCodeHelperTests",
            dependencies: ["SwiftCodeHelper"]),
    ]
)
