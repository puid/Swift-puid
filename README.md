# Puid

Simple, fast, flexible and efficient generation of probably unique identifiers (`puid`, aka random strings) of intuitively specified entropy using predefined or custom characters.

```swift
import Puid

let alphaId = try Puid(total: 1e5, risk: 1e12, chars: .alpha)
try alphaId.generate()
// => "uTJtdTPQFk"
```

<div align="leading">
  <a href="https://github.com/puid/Swift/actions/workflows/test.yml">
    <img src="https://github.com/puid/Swift/actions/workflows/test.yml/badge.svg" />
  </a>
  <a href="https://codecov.io/gh/puid/Swift-puid" >
    <img src="https://codecov.io/gh/puid/Swift-puid/branch/main/graph/badge.svg?token=JA5WRNFQDE"/>
  </a>
  <br/>
  <a href="https://swiftpackageindex.com/puid/Swift-puid" >
    <img src="https://img.shields.io/badge/SPM-compatible-orange?style=flat"/>
  </a>
  <a href="https://swiftpackageindex.com/puid/Swift-puid" >
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpuid%2FSwift-puid%2Fbadge%3Ftype%3Dswift-versions"/>
  </a>
  <a href="https://swiftpackageindex.com/puid/Swift-puid" >
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpuid%2FSwift-puid%2Fbadge%3Ftype%3Dplatforms"/>
  </a>
  <br/>  
  <a href="https://github.com/puid/Swift/blob/main/LICENSE" >
    <img src="https://img.shields.io/badge/license-MIT-orange?style=flat"/>
  </a>
</div>

## <a name="TOC"></a>TOC

- [Overview](#Overview)
- [Usage](#Usage)
  - [Entropy Source](#EntropySource)
  - [Characters](#Characters)
  - [Randomness](#Randomness)
- [Predefined Characters](#Chars)
- [Installation](#Installation)
- [License](#License)

## <a name="Overview"></a>Overview

`Puid` provides full, explicit control over all important facets of random ID generation: **_entropy source_**, **_characters_**, and desired **_randomness_**. A [general overview](https://github.com/puid/.github/blob/2381099d7f92bda47c35e8b5ae1085119f2a919c/profile/README.md) details information relevant to all **PUID** implementations.

[TOC](#TOC)

### <a name="Usage"></a>Usage

Creating a random ID generator using `Puid` is a simple as:

```swift
import Puid

let sessionId = try Puid()
try sessionId.generate()
// => "1Uyt1bj-cAgsHRpWjyPya6"
```

Options allow easy and complete control over random ID generation. The above example uses the default for each of:

- **entropy source**: Cryptographically strong random bytes
- **characters**: [File system & URL safe](https://tools.ietf.org/html/rfc4648#section-5) characters
- **randomness**: 128 bits of entropy 

These defaults are suitable for web session IDs.

[TOC](#TOC)

### <a name="EntropySource"></a>Entropy Source

`Puid` provides a CSPRNG entropy source (`Puid.Entropy.System.csprng`, using `SecCopyRandomBytes`) and a PRNG entropy source (`Puid.Entropy.System.prng`, using a seeded XorShift64* PRNG) via the `entropy` option:

```swift
let prngId = try Puid(entropy: .prng)
try prngId.generate()
// => "WONlvSz5wRzw6GUz1LqDTK"

let seeded = try Puid(entropy: .prngSeeded(seed: 42))
try seeded.generate()
// deterministic for the same seed
```

The `entropy` option can also designate any implementation of the `PuidEntropySource` protocol for using a custom entropy source:

```swift
let fixedBytes = Puid.Entropy.Fixed(hex: "d0 52 91 fd 13 62 16 fc bc 52 57 d1 a9 17 42 bf bf")
let fixedId = try Puid(entropy: fixedBytes)
try fixedId.generate()
// => "0FKR_RNiFvy8UlfRqRdCv7"
```

Note: The `Puid.Entropy.Fixed` source is convenient for deterministic testing but not suitable for general use.

A convenience class, `Puid.Entropy.Source`, provides a means of using any `RandomNumberGenerator` implementation as a `PuidEntropySource`. If, for example, you had a favorite PRNG, say `FavePrng`, that generates a repeatable sequence of random UInt64 numbers via an initialization seed, you could use that PRNG as an entropy source:

```swift
let favePrng = Puid.Entropy.Source(using: FavePrng(seed: 42))
let prngId = try Puid(entropy: favePrng)
try prngId.generate()
// => A puid generated using bytes from the custom FavePrng entropy source
```


[TOC](#TOC)

### <a name="Characters"></a>Characters

The characters used in ID generation are designated using the `chars` option. `Puid` provides a large set of predefined characters, as well as an option to specify any set of unique characters:

```swift
let alphaNumId = try Puid(chars: .alphaNum)
try alphaNumId.generate()
// => "cjm7wFkJQW5igrWUdjFnaA"

let customId = try Puid(chars: .custom("customID_CHARS"))
try customId.generate()
// => "oRmcAACtHsuAIuDSsooItACHIICo_S_IHo"
```

Note: `Puid` validates that the custom `chars` are unique to maximizes the entropy captured during ID generation.

[TOC](#TOC)

### <a name="Randomness"></a>Randomness

A critical aspect of random ID generation is, of course, the randomness of the IDs generated. `Puid` provides direct specification of ID randomness via the `bits` option for situations like session IDs (which are recommended to be 128-bit) or for 256-bit security tokens. But a more general, intuitive declaration of randomness is to explicitly specify the `total` number of IDs actually needed and assign an acceptable `risk` of repeat:

```swift
let randId = try Puid(total: 1e5, risk: 1e12, chars: .safe32)
try randId.generate()
// => "dqHqFD79QGd2TNP"
```

In the above example, a `total` of **100,000** IDs can be generated with a 1 in a trillion `risk` of repeat. Remember, **_all_** random ID generation has an **_inherent risk of repeat_**. There is simply no such thing as a _univerally unique_ ID, regardless of the UUID moniker. Rather than blindly use one-size-fits-all (which, for UUID, may be better described as an inefficient, one-size-fits-none solution), `Puid` allows full control so that risk can be _explicitly_ declared as appropriate for specific application need.

For those instances where `bits` of entropy is explicitly known:

```swift
let token = try Puid(bits: 256, chars: .hexUpper)
try token.generate()
// => "3AE2F836FB09E4D32850ABBA3A20A510B8F47D5CB8EA7CF6BFF10DE58F8FA7BD"
```

[TOC](#TOC)
### <a name="Chars"></a>Predefined Characters

The `Puid.Chars` enum includes predefined character sets:

| Name             | Characters                                                                                     |
| :--------------- | :--------------------------------------------------------------------------------------------- |
| .alpha           | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz                                           |
| .alphaLower      | abcdefghijklmnopqrstuvwxyz                                                                     |
| .alphaUpper      | ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                                     |
| .alphaNum        | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789                                 |
| .alphaNumLower   | abcdefghijklmnopqrstuvwxyz0123456789                                                           |
| .alphaNumUpper   | ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789                                                           |
| .base16          | 0123456789ABCDEF                                                                               |
| .base32          | ABCDEFGHIJKLMNOPQRSTUVWXYZ234567                                                               |
| .base32Hex       | 0123456789abcdefghijklmnopqrstuv                                                               |
| .base32HexUpper  | 0123456789ABCDEFGHIJKLMNOPQRSTUV                                                               |
| .base36          | 0123456789abcdefghijklmnopqrstuvwxyz                                                           |
| .base36Upper     | 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                           |
| .base58          | 123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz                                      |
| .base62          | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789                                 |
| .bech32          | 023456789acdefghjklmnpqrstuvwxyz                                                               |
| .boolean         | TF                                                                                              |
| .crockford32     | 0123456789ABCDEFGHJKMNPQRSTVWXYZ                                                               |
| .decimal         | 0123456789                                                                                     |
| .dna             | ACGT                                                                                           |
| .geohash         | 0123456789bcdefghjkmnpqrstuvwxyz                                                               |
| .hex             | 0123456789abcdef                                                                               |
| .hexUpper        | 0123456789ABCDEF                                                                               |
| .safeAscii       | !#$%&()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_abcdefghijklmnopqrstuvwxyz{|}~      |
| .safe32          | 2346789bdfghjmnpqrtBDFGHJLMNPQRT                                                               |
| .safe64          | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-\_                              |
| .symbol          | !#$%&()*+,-./:;<=>?@[]^_{|}~                                                                   |
| .urlSafe         | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~                              |
| .wordSafe32      | 23456789CFGHJMPQRVWXcfghjmpqrvwx                                                               |
| .zBase32         | ybndrfg8ejkmcpqxot1uwisza345h769                                                               |
| .symbol             | !#$%&()\*+,-./:;<=>?@[]^\_{\|}~                                                               |

`Puid.Chars.custom(String)` provides a mechanism to use any **String** of up to 256 unique characters for ID generation.

[TOC](#TOC)

### Metrics

Puid exposes character set metrics analogous to Puid.Chars.metrics/1 in the Elixir library. Use Puid.Chars.metrics(_:) to inspect bit slicing characteristics and efficiency values for any predefined or custom charset.

Example:

```swift
import Puid

let m = Puid.Chars.metrics(.safe64)
print(m.avgBits)    // 6.0
print(m.bitShifts)  // [(value: 63, shift: 6)]
print(m.ere)        // 0.75
print(m.ete)        // 1.0
```

[TOC](#TOC)

### <a name="Installation"></a>Installation

Swift Package Manager URL: https://github.com/puid/Swift-puid

[TOC](#TOC)

## License

MIT license. See [LICENSE](LICENSE.txt).
