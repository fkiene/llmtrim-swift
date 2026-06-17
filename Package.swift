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
            url: "https://github.com/fkiene/llmtrim/releases/download/v0.1.13/llmtrimFFI.xcframework.zip",
            checksum: "3764c198686a568b96e8bf540ccdd34000a34a5c24483add273ac3e282f25d91"
        ),
        .target(
            name: "Llmtrim",
            dependencies: ["llmtrimFFI"],
            path: "Sources/Llmtrim"
        ),
    ]
)
