// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EnhancedMediaPlayer",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "EnhancedMediaPlayer",
            targets: ["EnhancedMediaPlayer"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EnhancedMediaPlayer",
            dependencies: []
        ),
        .testTarget(
            name: "EnhancedMediaPlayerTests",
            dependencies: ["EnhancedMediaPlayer"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
