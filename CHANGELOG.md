# Changelog

## 2.0.0 (2025-09-06)

Breaking changes
- Puid.Entropy.System gained a new case .prngSeeded(seed:), which can break exhaustive switches in client code. This warrants a major version bump.
- PRNG semantics updated: .prng now uses a deterministic, non-cryptographic XorShift64* generator (seeded by uptime nanoseconds by default). Use .prngSeeded(seed:) for explicit seeding. The CSPRNG default remains unchanged.
- Public error surface refined: PuidError is now public, bytesFailure uses Int32 (cross-platform), and invalidEncoding carries a UInt8 index. Error description strings corrected for typos.

Additions
- RepeatRisk wrapper and overloads: init(total:risk:RepeatRisk, ...) for self-documenting "1 in N" risk, without increasing parameter count.
- Linux CSPrng source label clarified to "SystemRandomNumberGenerator" to reflect crypto-secure source on Linux.
- Swift 6 readiness: StrictConcurrency enabled for the target; Sendable annotations added where reasonable; @unchecked Sendable where appropriate; @preconcurrency on PuidEntropySource; final on Puid.Entropy.Fixed.
- Platforms expanded in Package.swift to include iOS, tvOS, watchOS.
- CI matrix expanded to macOS and Linux with Swift 5.9 and 5.10; Codecov upload on macOS.
- Linting/formatting in CI: SwiftLint (strict) and swift-format lint (macOS).
- DocC catalog added (Metrics page consolidating ERE/ETE); README updated with non-obvious character set descriptions and Metrics examples (.safe64 and .alpha).

Fixes/cleanup
- Settings initializer made non-throwing.
- Typos fixed in error messages ("exhausted", "not supported by encoder").

## 1.1.1 (2023-03-20)

### Code coverage 🤦🏽‍♂️
- For public properties added in 1.1.0

## 1.1.0 (2023-03-20)

### `RandomNumberGenerator` entropy source
- Enable any Swift `RandomNumberGenerator` to be used as a `PuidEntropySource`

### `Puid`
- Public access to individual **puid** generation properties
- Add `risk(after:)` function

### `PuidEntropySource` protocol
- Replace **func method(): String** with **var source: String**

### Cleanup

## 1.0.4 (2023-03-02)

### Data based tests
- Adjust Github workflow for data tests via submodule

## 1.0.3 (2023-03-01)

### Optimizations
- Maintain nChars in Bits class rather than access from Settings.chars
- Create lookup table for ndx shift value

## 1.0.2 (2023-02-23)

### OS Compatibility
- Restore iOS, tvOS and watchOS compatibility (after adding Linux)

## 1.0.1 (2023-02-23)

### Linux compatibility
- Conditional compilation for Linux CSPRNG entropy source

## 1.0.0 (2023-02-22)

Initial release
