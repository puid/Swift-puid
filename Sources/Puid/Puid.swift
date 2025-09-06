//
//  Puid
//
//  MIT License: See project LICENSE.txt
//

typealias Byte = UInt8
typealias Bytes = [Byte]

typealias PuidNdx = UInt8
typealias PuidNdxs = [PuidNdx]

/// A **PUID** generator
///
/// A **PUID** generator produces random IDs by _transforming_ an entropy source into _captured_ entropy
/// represented by a String result.
///
public struct Puid {
  let settings: Settings
  var puidBits: Puid.Bits
  var puidEncoder: PuidEncoderProtocol

  /// Create a **PUID** generator using `bits`
  ///
  /// - Parameter bits: Entropy `bits` for generated IDs
  /// - Parameter chars: `Puid.Chars`
  /// - Parameter entropy:`PuidEntropySource` implementation
  ///
  /// - Throws: `PuidError` if `custom` chars are not valid for **PUID** use
  ///
  /// ## Example
  /// ```swift
  /// let token = try Puid(bits: 256, chars: .hexUpper)
  /// try token.generate()
  /// // => "16C7C918E3D068507F529EB2B818767689B791A91A26EAD79C90AB7F2A42B1E9"
  /// ```
  ///
  /// Using explicit `bits` is useful when an external requirement is specified in bits, such as
  /// the entropy for a web session ID or generating a 256-bit token. Using `total/risk`
  /// is more appropriate for determining the required entropy bits in general cases.
  ///
  /// Generated **puid**s will have an entropy equal to a multiple of the entropy bits per ID
  /// character, which depends on the count of ID characters used. **PUID** ensures the entropy
  /// bits is equal to the first multiple of bits per character greater than the specifed `bits`.
  ///
  public init(
    bits: Double = Puid.Default.bits,
    chars: Puid.Chars = Puid.Default.chars,
    entropy: PuidEntropySource = Puid.Default.entropy
  ) throws {
    try chars.validate()

    settings = Settings(bits: bits, chars: chars, entropy: entropy)
    puidBits = Puid.Bits(settings: settings)
    puidEncoder = try Puid.Encoder.encoder(for: settings.chars)
  }

  /// Create a **PUID** generator using `bits`
  ///
  /// - Parameter bits: Entropy `bits` for generated IDs
  /// - Parameter chars: `Puid.Chars`
  /// - Parameter entropy: `Puid.Entropy.System`
  ///
  /// - Throws: `PuidError` if `chars` String is not valid for **PUID** use
  ///
  /// ## Example
  /// ```swift
  /// let alphaId = try Puid(bits: 64, chars: .alpha, entropy: .prng)
  /// try alphaId.generate()
  /// // => "avhYhXtUAhZK"
  /// ```
  ///
  /// Using explicit `bits` is useful when an external requirement is specified in bits, such as
  /// the entropy for a web session ID or generating a 256-bit token. Using `total/risk`
  /// is more appropriate for determining the required entropy bits in general cases.
  ///
  /// Generated **puid**s will have an entropy equal to a multiple of the entropy bits per ID
  /// character, which depends on the count of ID characters used. **PUID** ensures the entropy
  /// bits is equal to the first multiple of bits per character greater than the specifed `bits`.
  /// In the above example, the entropy of generated IDs is actually **68.41**.
  ///
  /// ### Note
  /// The `.prng` generator produces random bytes that are not cryptographically secure, but
  /// are suitable for circumstances where strict security characteristics are not required.
  ///
  public init(
    bits: Double = Puid.Default.bits,
    chars: Puid.Chars = Puid.Default.chars,
    entropy source: Puid.Entropy.System
  ) throws {
    try self.init(
      bits: bits,
      chars: chars,
      entropy: Puid.Entropy.system(source))
  }

  /// Create a **PUID** generator using `total/risk`
  ///
  /// - Parameter total: The `total` number of **puid**s that can be generated at the specified `risk`
  /// - Parameter risk: The `risk` of a duplicate **puid** when `total` IDs have been generated
  /// - Parameter chars: `Puid.Chars`
  /// - Parameter entropy:`PuidEntropySource` implementation
  ///
  /// - Throws: `PuidError` if `custom` chars are not valid for **PUID** use
  ///
  /// ## Example
  /// ```swift
  /// let entropy = Puid.Entropy.Fixed(hex: "A6 33 F6 9E BD EE A7 34")
  /// let dingoskyId = try Puid(total: 1_000, risk: 1e09, chars: .custom(chars: "dingosky"), entropy: entropy)
  /// try dingoskyId.generate()
  /// // => "siogiykkoysgkysks"
  /// ```
  ///
  /// Using `total/risk`  is an explicit way to intuitively specify ID randomness. The focus
  /// is not on knowing how many `bits` of entropy are needed or even how long the IDs will be,
  /// but instead on the more appropriate consideration of how many `total` IDs can be
  /// generated given an explicit `risk` of a repeat.
  ///
  /// In the example above, the code explicitly states that 1 thousand IDs are can to be generated
  /// with ID entropy sufficient to ensure a 1 in a billion chance of a repeat. In this case the
  /// entropy bits is  **51** and the IDs are 17 characters long, but that's a by-product of the
  /// explicit declaration of need, not the goal itself.
  public init(
    total: Double,
    risk: Double,
    chars: Puid.Chars = Puid.Default.chars,
    entropy: PuidEntropySource = Puid.Default.entropy
  ) throws {
    try self.init(
      bits: Puid.Entropy.bits(total: total, risk: risk),
      chars: chars,
      entropy: entropy)
  }

  /// Create a **PUID** generator
  ///
  /// - Parameter total: The `total` number of **puid**s that can be generated at the specified `risk`
  /// - Parameter risk: The `risk` of a duplicate **puid** when `total` IDs have been generated
  /// - Parameter chars: `Puid.Chars`
  /// - Parameter entropy: `Puid.Entropy.System`
  ///
  /// - Throws: `PuidError` if `chars` String is not valid for **PUID** use
  ///
  /// ## Example
  /// ```swift
  /// let alphaNumId = try Puid(total: 1e9, risk: 1e18, chars: .alphaNum)
  /// try alphaNumId.generate()
  /// // => "Zrwo0tuN9WsftGf7X1tV"
  /// ```
  ///
  /// Using `total/risk`  is an explicit way to intuitively specify ID randomness. The focus
  /// is not on knowing how many `bits` of entropy are needed or even how long the IDs will be,
  /// but instead on the more appropriate consideration of how many `total` IDs can be
  /// generated given an explicit `risk` of a repeat.
  ///
  /// In the example above, the code explicitly states that 1 thousand IDs are expected to be
  /// generated with ID entropy sufficient to ensure a 1 in a billion chance of a repeat. In this
  /// case the entropy bits is  **119** and the IDs are 20 characters long, but that's a
  /// by-product of the explicit declaration of need, not the goal itself.
  ///
  public init(
    total: Double,
    risk: Double,
    chars: Puid.Chars = Puid.Default.chars,
    entropy source: Puid.Entropy.System
  ) throws {
    try self.init(
      total: total,
      risk: risk,
      chars: chars,
      entropy: Puid.Entropy.system(source))
  }

  /// Generate a **puid**
  ///
  /// - Throws: `Puid.Error` if the associated bytes generator is unable to provide sufficient source entropy
  public func generate() throws -> String {
    try puidEncoder.encode(try puidBits.puidNdxs())
  }
  /// Approximate risk of repeat after generating some total number of IDs, expressed as 1 in risk chance.
  public func risk(after total: Double) -> Double {
    let risk = Entropy.risk(total: total, bits: settings.bits)
    return risk == 0 ? 0 : 1.0 / risk
  }
}

extension Puid {
  /// Bits of entropy for generated IDs
  public var bits: Double {
    settings.bits
  }

  /// Bits of entropy per character used in IDs
  public var bitsPerChar: Double {
    settings.bitsPerChar
  }

  /// Characters used in IDs
  public var chars: String {
    settings.chars.string
  }

  /// Entropy Representation Efficiency
  ///
  /// The ratio of random ID entropy to the number of bits required to represent the string.
  public var ere: Double {
    settings.ere
  }

  /// Entropy Source
  public var source: String {
    settings.entropy.source
  }

  public var length: Int {
    settings.length
  }
}

extension Puid: @unchecked Sendable {}

extension Puid: CustomStringConvertible {
  /// A listing of the parameterization of a **PUID** generator
  public var description: String {
    "Puid:\n\(settings.description)"
  }
}

extension Puid {
  /// Defaults used for **PUID** generator initilization
  public struct Default {
    /// 128
    ///
    /// **PUID** entropy is a multiple of the entropy bits per character, which is dependent on the count of characters used in
    /// ID generation. The actual `bits` of entropy for generated **puid**s will be the next multiple greater than `bits`
    ///
    public static let bits = 128.0

    /// The [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5) file system and URL safe character set
    ///
    /// ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_
    ///
    public static let chars = Puid.Chars.safe64

    /// Entropy source using system crytographically strong bytes
    public static let entropy = Puid.Entropy.system(.csprng)
  }
}
