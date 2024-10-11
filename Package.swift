// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "ReerKit",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v4),
        .macOS(.v10_13),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "ReerKit", targets: ["ReerKit"])
    ],
    targets: [
        .target(
            name: "ReerKit",
            path: "Sources",
            resources: [.process("Resources/PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "ReerKitTests",
            dependencies: ["ReerKit"],
            path: "Tests",
            resources: [.process("ResourcesTests/Resources")])
    ]
)
