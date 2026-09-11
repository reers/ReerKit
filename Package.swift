// swift-tools-version:5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "ReerKit",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v4),
        .macOS(.v10_15),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "ReerKit", targets: ["ReerKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.0"..<"606.0.0")
    ],
    targets: [
        .target(
            name: "ReerKit",
            dependencies: ["ReerKitMacros"],
            resources: [.process("Resources/PrivacyInfo.xcprivacy")]
        ),
        .macro(
            name: "ReerKitMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .testTarget(
            name: "ReerKitTests",
            dependencies: ["ReerKit"],
            path: "Tests",
            exclude: ["MacroTests"],
            resources: [.process("ResourcesTests/Resources")]
        ),
        .testTarget(
            name: "ReerKitMacroTests",
            dependencies: [
                "ReerKit",
                "ReerKitMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ],
            path: "Tests/MacroTests"
        )
    ]
)
