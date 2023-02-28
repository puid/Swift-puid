# Puid

<div align="leading">
  <a href="https://github.com/puid/Swift/actions/workflows/test.yml">
    <img src="https://github.com/puid/Swift/actions/workflows/test.yml/badge.svg" />
  </a>
  <a href="https://codecov.io/github/puid/Swift" >
    <img src="https://codecov.io/github/puid/Swift/branch/main/graph/badge.svg"/>
  </a>
  <a href="https://github.com/puid/Swift/blob/main/LICENSE" >
    <img src="https://img.shields.io/badge/license-MIT-orange?style=flat"/>
  </a>

  <br/>
  <a href="https://swiftpackageindex.com/puid/Swift" >
    <img src="https://img.shields.io/badge/SPM-compatible-orange?style=flat"/>
  </a>
  <a href="https://swiftpackageindex.com/puid/Swift" >
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpuid%2FSwift%2Fbadge%3Ftype%3Dswift-versions"/>
  </a>
  <a href="https://swiftpackageindex.com/puid/Swift" >
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpuid%2FSwift%2Fbadge%3Ftype%3Dplatforms"/>
  </a>
</div>

Simple, fast, flexible and efficient generation of probably unique identifiers (`puid`, aka random strings) of intuitively specified entropy using pre-defined or custom characters.

```swift
import Puid

let alphaId = try Puid(total: 1e5, risk: 1e12, chars: .alpha)
try alphaId.generate()
// => "uTJtdTPQFk"
```

## <a name="TOC"></a>TOC

- [Overview](#Overview)
- [Usage](#Usage)
  - [Entropy Source](#EntropySource)
  - [Characters](#Characters)
  - [Randomness](#Randomness)
- [Installation](#Installation)
- [Module API](#ModuleAPI)
- [Chars](#Chars)
- [License](#License)

## <a name="Overview"></a>Overview

`Puid` provides full, explicit control over all important facets of random ID generation: **entropy source**, **characters**, and desired **randomness**. A [general overview](https://github.com/puid/.github/blob/2381099d7f92bda47c35e8b5ae1085119f2a919c/profile/README.md) details information relevant to all **PUID** implementations.

[TOC](#TOC)

### <a name="Usage"></a>Usage

Creating a random ID generator using `Puid` is a simple as:

```swift
import Puid

let sessionId = try Puid()
try sessionId.generate()
// => "1Uyt1bj-cAgsHRpWjyPya6"
```

Options allow easy and complete control of **entropy source**, **characters**, and desired **randomness**. The above example uses the default for each:

- **entropy source**: Cryptographically strong random bytes
- **characters**: [File system & URL safe](https://tools.ietf.org/html/rfc4648#section-5) characters
- **randomness**: 128 bits of entropy 

These defaults are suitable for web session IDs.

[TOC](#TOC)

### <a name="EntropySource"></a>Entropy Source

`Puid` provides a CSPRNG entropy source (`Puid.Entropy.Source.csprng`, using `SecCopyRandomBytes`) and a PRNG entropy source (`Puid.Entropy.Source.prng`, using `UInt8.random`) via the `entropy` option:

```swift
let prngId = try Puid(entropy: .prng)
try prngId.generate()
// => "WONlvSz5wRzw6GUz1LqDTK"
```

The `entropy` option can also designate any implementation of the `PuidEntropySource` protocol for using a custom entropy source:

```swift
let fixedBytes = Puid.Entropy.Fixed(hex: "d0 52 91 fd 13 62 16 fc bc 52 57 d1 a9 17 42 bf bf")
let fixedId = try Puid(entropy: fixedBytes)
try fixedId.generate()
// => "0FKR_RNiFvy8UlfRqRdCv7"
```

Note: The `Puid.Entropy.Fixed` source is convenient for deterministic testing but not suitable for general use.

[TOC](#TOC)

### <a name="Characters"></a>Characters

The characters used in ID generation are designated using the `chars` option. `Puid` provides 17 predefined characters sets, as well as an option to specify any set of unique characters:

```swift
let alphaNumId = try Puid(chars: .alphaNum)
try alphaNumId.generate()
// => "cjm7wFkJQW5igrWUdjFnaA"

let customId = try Puid(chars: .custom("customID_CHARS"))
try customId.generate()
// => "oRmcAACtHsuAIuDSsooItACHIICo_S_IHo"
```

Note: `Puid` validates custom chars are unique to maximizes the entropy captured during ID generation.

[TOC](#TOC)

### <a name="Randomness"></a>Randomness

A critical aspect of random ID generation is, of course, the randomness of the IDs generated. `Puid` provides direct specification of ID randomness via the `bits` option for situations like session IDs (which are recommended to be 128-bit) or for 256-bit security tokens. But a more general, intuitive declaration of randomness is to consider the `total` number of IDs actually needed and assign an acceptable `risk` of repeat:

```swift
let randId = try Puid(total: 1e5, risk: 1e12, chars: .safe32)
try randId.generate()
// => "dqHqFD79QGd2TNP"
```

In the above example, a `total` of **100,000** IDs can be generated with a 1 in a trillion `risk` of repeat. Remember, _**all**_ random ID generation has an inherent _**risk of repeat**_. There is simply no such thing as a _univerally unique_ ID, regardless of the UUID moniker. Rather than blindly use one-size-fits-all (which, for UUID, may be better described as an inefficient, one-size-fits-none solution), `Puid` allows full control so that risk can be _explicitly_ declared as appropriate for specific application need.

For those instances where `bits` of entropy is explicitly desired:

```swift
let token = try Puid(bits: 256, chars: .hexUpper)
try token.generate()
// => "3AE2F836FB09E4D32850ABBA3A20A510B8F47D5CB8EA7CF6BFF10DE58F8FA7BD"
```

[TOC](#TOC)

### <a name="Installation"></a>Installation

Swift Package Manager URL: https://github.com/puid/Swift-puid

[TOC](#TOC)

## License

MIT license. See [LICENSE](LICENSE.txt).
