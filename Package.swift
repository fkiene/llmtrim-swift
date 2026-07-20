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
            url: "https://github.com/fkiene/llmtrim/releases/download/v0.11.5/llmtrimFFI.xcframework.zip",
            checksum: "97e6d6961e4ea820e968defd3d5ffc05100de8af12bc0acb245383d6e63e7226"
        ),
        .target(
            name: "Llmtrim",
            dependencies: ["llmtrimFFI"],
            path: "Sources/Llmtrim"
        ),
    ]
)
