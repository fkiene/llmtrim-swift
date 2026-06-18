<p align="center">
  <img src="https://raw.githubusercontent.com/fkiene/llmtrim/main/assets/logo.svg" alt="llmtrim" width="140">
</p>

<h1 align="center">Llmtrim for Swift</h1>

<p align="center">
  <strong>Cut your LLM bill from Swift. Compress an API request before you send it, get the same answer for fewer tokens.</strong>
</p>

<p align="center">
  <a href="https://swiftpackageindex.com/fkiene/llmtrim-swift"><img src="https://img.shields.io/badge/SwiftPM-compatible-brightgreen" alt="SwiftPM"></a>
  <img src="https://img.shields.io/badge/platforms-macOS%20%7C%20iOS-blue" alt="platforms">
  <a href="https://github.com/fkiene/llmtrim/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="License: AGPL v3"></a>
</p>

This is the Swift package for [llmtrim](https://github.com/fkiene/llmtrim), a static,
deterministic LLM prompt compressor. It takes a provider-shaped request (OpenAI, Anthropic
or Google JSON), strips the wasted tokens with deterministic algorithms only (no auxiliary
model, no network), and hands back a smaller request. Typical savings are 30 to 90% of
input tokens, with no change to the answer.

The compression engine is a prebuilt XCFramework, so there is no Rust toolchain to install.

## Install

In Xcode: **File → Add Package Dependencies** and enter `https://github.com/fkiene/llmtrim-swift`.

Or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/fkiene/llmtrim-swift", from: "0.2.0"),
]
```

## Use it

```swift
import Llmtrim

let request = #"{"model":"gpt-4o","messages":[{"role":"user","content":"…"}]}"#

let out = try compress(input: request, provider: .openAi, preset: "aggressive")
print("\(out.inputTokensBefore) -> \(out.inputTokensAfter) input tokens")
// send out.requestJson to the provider
```

`compress(input:provider:preset:)`:

- `provider` is `.openAi`, `.anthropic`, `.google`, or `nil` to auto-detect from the body.
- `preset` is a workload name (`"aggressive"`, `"agent"`, `"code"`, `"rag"`, `"safe"`, …)
  or `nil` for the environment configuration.
- It returns a `CompressOutput` with the compressed `requestJson` and the before/after
  token counts, and throws `LlmtrimError.compress` / `.unknownPreset` on failure.

> [!IMPORTANT]
> It can never make the request bigger or break it. Every step is re-measured with the
> provider's real tokenizer; a step that does not save tokens is reverted. Anything under a
> `cache_control` marker is left byte-identical so the prompt cache stays warm. Worst case
> is zero savings, never a worse outcome.

## How this package is built

The Swift API in `Sources/Llmtrim/` is generated from the Rust engine via
[UniFFI](https://mozilla.github.io/uniffi-rs/), and the native code is the
`llmtrimFFI.xcframework` attached to the matching [llmtrim release](https://github.com/fkiene/llmtrim/releases).
`Package.swift` pins both by version and checksum. The CLI, the proxy, and the other
language bindings (Python, Ruby, Kotlin) live in the [main repository](https://github.com/fkiene/llmtrim).
