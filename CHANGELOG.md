# Changelog

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
