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
        .package(
            url: "https://github.com/swift-compositions/swift-client-derivation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-compositions/swift-signature-derivation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-either.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-optic.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-compositions/swift-client.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-institute/swift-example.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Example Greeting Signature",
            dependencies: [
                .product(name: "Example", package: "swift-example"),
                .product(name: "Example Greeting", package: "swift-example"),
                .product(name: "Client", package: "swift-client"),
                .product(name: "Client Derivation", package: "swift-client-derivation"),
                .product(name: "Signature Derivation", package: "swift-signature-derivation"),
            ]
        ),
        .target(
            name: "Example Counter Signature",
            dependencies: [
                .product(name: "Example", package: "swift-example"),
                .product(name: "Example Counter", package: "swift-example"),
                .product(name: "Client", package: "swift-client"),
                .product(name: "Client Derivation", package: "swift-client-derivation"),
                .product(name: "Signature Derivation", package: "swift-signature-derivation"),
            ]
        ),
        .target(
            name: "Example Signature",
            dependencies: [
                .product(name: "Example", package: "swift-example"),
                .product(name: "Example Greeting", package: "swift-example"),
                .product(name: "Example Counter", package: "swift-example"),
                .product(name: "Client", package: "swift-client"),
                .product(name: "Client Derivation", package: "swift-client-derivation"),
                .product(name: "Signature Derivation", package: "swift-signature-derivation"),
                "Example Greeting Signature",
                "Example Counter Signature",
            ]
        ),
        .testTarget(
            name: "Example Signature Tests",
            dependencies: [
                .product(name: "Example", package: "swift-example"),
                .product(name: "Example Greeting", package: "swift-example"),
                .product(name: "Example Counter", package: "swift-example"),
                .product(name: "Client", package: "swift-client"),
                .product(name: "Client Derivation", package: "swift-client-derivation"),
                .product(name: "Signature Derivation", package: "swift-signature-derivation"),
                .product(name: "Either", package: "swift-either"),
                .product(name: "Optic", package: "swift-optic"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Tagged Standard Library Integration", package: "swift-tagged"),
                "Example Greeting Signature",
                "Example Counter Signature",
                "Example Signature",
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
