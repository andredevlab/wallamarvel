// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "CoreNetwork",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "CoreNetwork",
            targets: ["CoreNetwork"]
        )
    ],
    targets: [
        .target(
            name: "CoreNetwork",
            path: "Sources/CoreNetwork"
        ),
        .testTarget(
            name: "CoreNetworkTests",
            dependencies: ["CoreNetwork"]),
    ]
)
