// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KituraOpenAPI",
    products: [
        .library(
            name: "KituraOpenAPI",
            targets: ["KituraOpenAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Kitura/Kitura.git", from: "2.9.200"),
        .package(url: "https://github.com/Kitura/Swift-cfenv.git", from: "6.0.200"),
        .package(url: "https://github.com/Kitura/LoggerAPI.git", from: "1.9.200"),
    ],
    targets: [
        .target(
            name: "KituraOpenAPI",
            dependencies: ["Kitura", "CloudFoundryEnv", "LoggerAPI"]),
        .testTarget(
            name: "KituraOpenAPITests",
            dependencies: ["KituraOpenAPI", "Kitura"]),
    ]
)
