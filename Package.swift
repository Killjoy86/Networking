// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "Networking", targets: ["Networking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Killjoy86/Domain", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Moya", package: "Moya"),
                .product(name: "CombineMoya", package: "Moya"),
            ],
            resources: [
                .process("Mocks/character.json"),
                .process("Mocks/characters.json"),
            ]
        ),
        .testTarget(name: "NetworkingTests", dependencies: ["Networking"]),
    ]
)
