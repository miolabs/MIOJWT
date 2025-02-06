// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MIOJWT",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MIOJWT",
            targets: ["MIOJWT"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", "3.8.0"..<"5.0.0" ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MIOJWT",
            dependencies: [
                .product( name: "Crypto", package: "swift-crypto" ),
                .product( name: "_CryptoExtras", package: "swift-crypto" ),
            ]
        ),
        .testTarget(
            name: "MIOJWTTests",
            dependencies: ["MIOJWT"]
        ),
    ]
)
