// swift-tools-version:5.2

import PackageDescription

var package = Package(
    name: "SwiftyLine",
    platforms: [.macOS("10.10")],
    products: [
        .library(name: "SwiftyLine", targets: ["SwiftyLine"])
    ],
    dependencies: [],
    targets: [
        .target(name: "SwiftyLine"),
        .target(name: "Example", dependencies: ["SwiftyLine"])
    ]
)
