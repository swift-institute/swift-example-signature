// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-example-signature",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Example Greeting Signature",
            targets: ["Example Greeting Signature"]
        ),
        .library(
            name: "Example Counter Signature",
            targets: ["Example Counter Signature"]
        ),
        .library(
            name: "Example Signature",
            targets: ["Example Signature"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-institute/swift-example.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Example Greeting Signature",
            dependencies: [
                .product(name: "Example", package: "swift-example"),
            ]
        ),
        .target(
            name: "Example Counter Signature",
            dependencies: [
                .product(name: "Example", package: "swift-example"),
            ]
        ),
        .target(
            name: "Example Signature",
            dependencies: [
                .product(name: "Example", package: "swift-example"),
            ]
        ),
        .testTarget(
            name: "Example Signature Tests",
            dependencies: [
                "Example Signature",
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
