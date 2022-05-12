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
        .package(path: "/Users/roman.syrota/Documents/CleanArchitecture/Domain"),
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
            exclude: [
                "Mocks/character.json",
                "Mocks/characters.json"
            ]
        ),
        .testTarget(name: "NetworkingTests", dependencies: ["Networking"]),
    ]
)
