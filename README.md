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

// Using a self-documenting risk wrapper (same result)
let wrapped = try Puid(total: 100_000, risk: RepeatRisk.oneIn(1e12), chars: .safe32)
try wrapped.generate()
```

In the above example, a `total` of **100,000** IDs can be generated with a 1 in a trillion `risk` of repeat. Remember, **_all_** random ID generation has an **_inherent risk of repeat_**. There is simply no such thing as a _univerally unique_ ID, regardless of the UUID moniker. Rather than blindly use one-size-fits-all (which, for UUID, may be better described as an inefficient, one-size-fits-none solution), `Puid` allows full control so that risk can be _explicitly_ declared as appropriate for specific application need.

For those instances where `bits` of entropy is explicitly known:

```swift
let token = try Puid(bits: 256, chars: .hexUpper)
try token.generate()
// => "3AE2F836FB09E4D32850ABBA3A20A510B8F47D5CB8EA7CF6BFF10DE58F8FA7BD"
```

#### Encode / Decode

Convert between puid strings and representative bits.

- encode(bits:): Accepts exactly the required number of bytes for this generator (ceil(ceil(bitsPerChar) * length / 8)). Throws on invalid size or if any sliced index exceeds the charset size.
- decode(_:): Returns representative bytes for this generator. Supported for ASCII charsets only; throws for non-ASCII charsets or length mismatch.

These functions facilitate storing a binary value of generated IDs while providing a means of recovering the puid String from that binary.  They DO NOT provide a a generic binary encoding like Base64. Only the leading ceil(bitsPerChar) bits per character are used. Any unused trailing bits in the last byte are ignored by encode and zeroed by decode. Therefore, bytes -> encode -> decode does not guarantee an exact byte-for-byte round trip. However, puid -> decode -> encode will round-trip the puid string exactly. 



```swift
import Puid

let alphaId = try Puid(bits: 55, chars: .alphaLower)
let puid = try alphaId.generate() // "arcdpmdppsmh"
let bytes = try alphaId.decode(puid) // [0x04, 0x44, 0x37, 0xb0, 0x6f, 0x7c, 0x98, 0x70]
let puid2 = try alphaId.encode(bits: bytes) // "rwfafkahbmgq"
assert(puid2 == puid)
```

[TOC](#TOC)
### <a name="Chars"></a>Predefined Character Sets

| Name | Count | ERE | ETE | Characters |
|------|--------|-----|-----|------------|
| .alpha | 52 | 5.7 | 0.84 | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz |
| .alphaLower | 26 | 4.7 | 0.81 | abcdefghijklmnopqrstuvwxyz |
| .alphaUpper | 26 | 4.7 | 0.81 | ABCDEFGHIJKLMNOPQRSTUVWXYZ |
| .alphaNum | 62 | 5.95 | 0.97 | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 |
| .alphaNumLower | 36 | 5.17 | 0.65 | abcdefghijklmnopqrstuvwxyz0123456789 |
| .alphaNumUpper | 36 | 5.17 | 0.65 | ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 |
| .base16 | 16 | 4.0 | 1.0 | 0123456789ABCDEF |
| .base32 | 32 | 5.0 | 1.0 | ABCDEFGHIJKLMNOPQRSTUVWXYZ234567 |
| .base32Hex | 32 | 5.0 | 1.0 | 0123456789abcdefghijklmnopqrstuv |
| .base32HexUpper | 32 | 5.0 | 1.0 | 0123456789ABCDEFGHIJKLMNOPQRSTUV |
| .base36 | 36 | 5.17 | 0.65 | 0123456789abcdefghijklmnopqrstuvwxyz |
| .base36Upper | 36 | 5.17 | 0.65 | 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ |
| .base58 | 58 | 5.86 | 0.91 | 123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz |
| .base62 | 62 | 5.95 | 0.97 | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 |
| .bech32 | 32 | 5.0 | 1.0 | 023456789acdefghjklmnpqrstuvwxyz |
| .boolean | 2 | 1.0 | 1.0 | TF |
| .crockford32 | 32 | 5.0 | 1.0 | 0123456789ABCDEFGHJKMNPQRSTVWXYZ |
| .decimal | 10 | 3.32 | 0.62 | 0123456789 |
| .dna | 4 | 2.0 | 1.0 | ACGT |
| .geohash | 32 | 5.0 | 1.0 | 0123456789bcdefghjkmnpqrstuvwxyz |
| .hex | 16 | 4.0 | 1.0 | 0123456789abcdef |
| .hexUpper | 16 | 4.0 | 1.0 | 0123456789ABCDEF |
| .safeAscii | 90 | 6.49 | 0.8 | !#$%&()\*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ\[\]^\_abcdefghijklmnopqrstuvwxyz{\|}~ |
| .safe32 | 32 | 5.0 | 1.0 | 2346789bdfghjmnpqrtBDFGHJLMNPQRT |
| .safe64 | 64 | 6.0 | 1.0 | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-\_ |
| .symbol | 28 | 4.81 | 0.89 | !#$%&()\*+,-./:;<=>?@\[\]^\_{\|}~ |
| .urlSafe | 66 | 6.04 | 0.63 | ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-.\_~ |
| .wordSafe32 | 32 | 5.0 | 1.0 | 23456789CFGHJMPQRVWXcfghjmpqrvwx |
| .zBase32 | 32 | 5.0 | 1.0 | ybndrfg8ejkmcpqxot1uwisza345h769 |


Note: The [Metrics](#metrics) section explains ERE and ETE.

[TOC](#TOC)

#### Description of non-obvious character sets

| Name               | Description                                                |
| :----------------- | :--------------------------------------------------------- |
| .base16            | https://datatracker.ietf.org/doc/html/rfc4648#section-8   |
| .base32            | https://datatracker.ietf.org/doc/html/rfc4648#section-6   |
| .base32Hex         | Lowercase of .base32HexUpper                               |
| .base32HexUpper    | https://datatracker.ietf.org/doc/html/rfc4648#section-7   |
| .base36            | Used by many URL shorteners                                |
| .base58            | Bitcoin base58 alphabet (excludes 0, O, I, l)             |
| .bech32            | Bitcoin SegWit address encoding                            |
| .dna               | DNA nucleotide bases (Adenine, Cytosine, Guanine, Thymine) |
| .crockford32       | https://www.crockford.com/base32.html                      |
| .geohash           | Used for encoding geographic coordinates                   |
| .safeAscii         | Printable ASCII that does not require escape in String     |
| .safe32            | Letters/numbers picked to reduce chance of English words   |
| .safe64            | https://datatracker.ietf.org/doc/html/rfc4648#section-5    |
| .urlSafe           | https://datatracker.ietf.org/doc/html/rfc3986#section-2.3  |
| .wordSafe32        | Letters/numbers picked to reduce chance of English words   |
| .zBase32           | Zooko’s Base32                                             |

#### Custom

Any `String` of up to 256 unique characters can be used for **`puid`** generation, with custom characters optimized in the same manner as the pre-defined character sets. The characters must be unique. This isn't strictly a technical requirement, **PUID** could handle duplicate characters, but the resulting randomness of the IDs is maximal when the characters are unique, so **PUID** enforces that restriction.


### Metrics

#### Entropy Representation Efficiency

Entropy Representation Efficiency (ERE) is a measure of how efficient a string ID represents the entropy of the ID itself. When referring to the entropy of an ID, we mean the Shannon Entropy of the character sequence, and that is maximal when all the permissible characters are equally likely to occur. In most random ID generators, this is the case, and the ERE is solely dependent on the count of characters in the charset, where each character represents **log2(count)** of entropy (a computer specific calc of general Shannon entropy). For example, for a hex charset there are **16** hex characters, so each character "carries" **log2(16) = 4** bits of entropy in the string ID. We say the bits per character is **4** and a random ID of **12** hex characters has **48** bits of entropy.

ERE is measured as a ratio of the bits of entropy for the ID divided by the number of bits require to represent the string (**8** bits per ID character). If each character is equally probably (the most common case), ERE is **(bits-per-char * id_len) / (8 bits * id_len)**, which simplifies to **bits-per-character/8**. The BPC displayed in the Puid Characters table is equivalent to the ERE for that charset.

There is, however, a particular random ID exception where each character is _**not**_ equally probable, namely, the often used v4 format of UUIDs. In that format, there are hyphens that carry no entropy (entropy is uncertainty, and there is _**no uncertainly**_ as to where those hyphens will be), one hex digit that is actually constrained to 1 of only 4 hex values and another that is fixed. This formatting results in a ID of 36 characters with a total entropy of 122 bits. The ERE of a v4 UUID is, therefore, **122 / (8 * 36) = 0.4236**.

#### Entropy Transform Efficiency

Entropy Transform Efficiency (ETE) is a measure of how efficiently source entropy is transformed into random ID entropy. For charsets with a character count that is a power of 2, all of the source entropy bits can be utilized during random ID generation. Each generated ID character requires exactly **log2(count)** bits, so the incoming source entropy can easily be carved into appropriate indices for character selection. Since ETE represents the ratio of output entropy bits to input entropy source, when all of the bits are utilized ETE is **1.0**.

Even for charsets with power of 2 character count, ETE is only the theoretical maximum of **1.0** _**if**_ the input entropy source is used as described above. Unfortunately, that is not the case with many random ID generation schemes. Some schemes use the entire output of a call to source entropy to create a single index used to select a character. Such schemes have very poor ETE.

For charsets with a character count that is not a power of 2, some bits will inevitably be discarded since the smallest number of bits required to select a character, **ceil(log2(count))**, will potentially result in an index beyond the character count. A first-cut, naïve approach to this reality is to simply throw away all the bits when the index is too large.

However, a more sophisticated scheme of bit slicing can actually improve on the naïve approach. Puid extends the bit slicing scheme by adding a bit shifting scheme to the algorithm, wherein a _**minimum**_ number of bits in the "over the limit" bits are discarded by observing that some bit patterns of length less than **ceil(log2(count))** already guarantee the bits will be over the limit, and _**only**_ those bits need be discarded. 

As example, using the **:alphanum_lower** charset, which has 36 characters, **ceil(log2(36)) = 6** bits are required to create a suitable index. However, if those bits start with the bit pattern **11xxxx**, the index would be out of bounds regardless of the **xxxx** bits, so Puid only tosses the first two bits and keeps the trailing four bits for use in the next index. (It is beyond scope to discuss here, but analysis shows this bit shifting scheme does not alter the random characteristics of generated IDs). So whereas the naïve approach would have an ETE of **0.485**, Puid achieves an ETE of **0.646**, a **33%** improvement. 

#### Example

```swift
import Puid

let safe = Puid.Chars.metrics(.safe64)
print(safe.avgBits)    // 6.0
print(safe.bitShifts)  // [BitShift(value: 63, shift: 6)]
print(safe.ere)        // 0.75
print(safe.ete)        // 1.0

let alpha = Puid.Chars.metrics(.alpha)
print(alpha.avgBits)   // > 6.0 (accounts for rare rejects)
print(alpha.bitShifts) // e.g., [BitShift(value: 51, shift: 6), ...]
print(alpha.ere)       // ~0.71 (5.7 / 8)
print(alpha.ete)       // < 1.0 (non power-of-two charset)
```

#### Risk helpers

These helpers return the maximum total number of IDs before reaching a repeat threshold, and the 1‑in‑N risk for a given total.

- total(atRiskProbability:): Accepts a probability p in (0, 1).
- total(atRiskOneIn:): Accepts a one‑in‑X threshold X > 1.
- risk(after:): Returns a 1‑in‑N value (Double) for the chance of at least one repeat after generating the given total.

```swift
import Puid

let id = try Puid(bits: 128, chars: .safe64)

// One‑in‑X form (e.g., one‑in‑a‑trillion)
let maxAtOneIn = id.total(atRiskOneIn: 1e12)

// Probability form (e.g., 1e‑12)
let maxAtProbability = id.total(atRiskProbability: 1e-12)

// Risk as 1‑in‑N for a given total
let oneIn = id.risk(after: 1_000_000)
```

[TOC](#TOC)

### <a name="Installation"></a>Installation

Swift Package Manager URL: https://github.com/puid/Swift-puid

[TOC](#TOC)

## License

MIT license. See [LICENSE](LICENSE.txt).
