// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ReerKit",
    platforms: [
        .iOS(.v11),
        .tvOS(.v9),
        .watchOS(.v2),
        .macOS(.v10_10)
    ],
    products: [
        .library(name: "ReerKit", targets: ["ReerKit"])
    ],
    targets: [
        .target(name: "ReerKit", path: "Sources"),
        .testTarget(
            name: "ReerKitTests",
            dependencies: ["ReerKit"],
            path: "Tests",
            resources: [.process("ResourcesTests/Resources")])
    ])
