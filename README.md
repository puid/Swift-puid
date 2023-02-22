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
</div>

Simple, fast, flexible and efficient generation of probably unique identifiers (`puid`, aka random strings) of intuitively specified entropy using pre-defined or custom characters.

```swift
import Puid

let alphaId = Puid(total: 1e5, risk: 1e12, charSet: .alpha)
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

## <a name="Overview"></a>Overview

A general overview of [PUID](https://github.com/puid/.github/blob/2381099d7f92bda47c35e8b5ae1085119f2a919c/profile/README.md) provides information relevant to all **PUID** implementations.

[TOC](#TOC)

### <a name="Usage"></a>Usage

Creating a random ID generator using `Puid` is a simple as:

```swift
import Puid

let sessionId = Puid()
try sessionId.generate()
// => "1Uyt1bj-cAgsHRpWjyPya6"
```

Options allow easy and complete control of all important facets of ID generation: **entropy source**, **characters**, and desired **randomness**. Using the default parameters, as in the above example, `Puid` generates IDs suitable for use as web session IDs. The defaults are:

- entropy source: Cryptographically strong random bytes (`Puid.Entropy.Source.csprng`)
- characters: [File system & URL safe](https://tools.ietf.org/html/rfc4648#section-5) characters (`Puid.Chars.safe64`)
- randomness: **128** bits of entropy

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

In the above example, a `total` of **100,000** IDs can be generated with a 1 in a trillion `risk` of repeat. Remember, _**all**_ random ID generation has an inherent _**risk of repeat**_. Rather than blindly use one-size-fits-all (e.g. UUID, which may be better described as an inefficient, one-size-fits-none solution), `Puid` allows full control so that risk can be _explicitly_ declared as appropriate for specific application need.

For those instances where explicit `bits` of entropy is known:

```swift
let token = try Puid(bits: 256, chars: .hexUpper)
try token.generate()
// => "3AE2F836FB09E4D32850ABBA3A20A510B8F47D5CB8EA7CF6BFF10DE58F8FA7BD"
```

[TOC](#TOC)

### <a name="Installation"></a>Installation

Swift Package Manager URL: https://github.com/puid/Swift

[TOC](#TOC)
