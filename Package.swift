// swift-tools-version:5.9
import PackageDescription

// Swift distribution for llmtrim. The compression engine ships as a prebuilt XCFramework
// attached to each llmtrim release; this package wraps it so SwiftPM consumers get a
// normal `import Llmtrim` with no Rust toolchain. The version below tracks an llmtrim
// release tag; bump the url + checksum together when moving to a newer one.
let package = Package(
    name: "Llmtrim",
    platforms: [.macOS(.v11), .iOS(.v13)],
    products: [
        .library(name: "Llmtrim", targets: ["Llmtrim"]),
    ],
    targets: [
        .binaryTarget(
            name: "llmtrimFFI",
            url: "https://github.com/fkiene/llmtrim/releases/download/v0.1.10/llmtrimFFI.xcframework.zip",
            checksum: "f6deeb56df5304df9b7b4feb696a08391ae30e04446ffd0fc8f91a62726f79a8"
        ),
        .target(
            name: "Llmtrim",
            dependencies: ["llmtrimFFI"],
            path: "Sources/Llmtrim"
        ),
    ]
)
