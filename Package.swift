// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MP3Joiner",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "MP3Joiner", targets: ["MP3Joiner"])
    ],
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.6.0")
    ],
    targets: [
        .executableTarget(
            name: "MP3Joiner",
            dependencies: [
                .product(name: "Sparkle", package: "Sparkle")
            ]
        )
    ]
)
