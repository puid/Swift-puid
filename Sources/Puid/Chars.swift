//
//  Puid.Chars
//  
//  MIT License: See project LICENSE.txt
//

extension Puid {
  /// Predefined characters for use in **PUID** initialization
  public enum Chars {
    /// Upper/lower case alphabet
    ///
    /// ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz
    ///
    /// Entropy bits per character: `5.7`
    case alpha
    
    /// Lower case alphabet
    ///
    /// abcdefghijklmnopqrstuvwxyz
    ///
    /// Entropy bits per character: `4.7`
    case alphaLower
    
    /// Upper case alphabet
    ///
    /// ABCDEFGHIJKLMNOPQRSTUVWXYZ
    ///
    /// Entropy bits per character: `4.7`
    case alphaUpper
    
    /// Upper/lower alphabet and numbers
    ///
    /// ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
    ///
    /// Entropy bits per character: `5.95`
    case alphaNum
    
    /// Llower alphabet and numbers
    ///
    /// abcdefghijklmnopqrstuvwxyz0123456789
    ///
    /// Entropy bits per character: `5.17`
    case alphaNumLower
    
    /// Upper alphabet and numbers
    ///
    /// ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
    ///
    /// Entropy bits per character: `5.17`
    case alphaNumUpper
    
    /// [RFC 4648](https://tools.ietf.org/html/rfc4648#section-6) base32 character set
    ///
    /// ABCDEFGHIJKLMNOPQRSTUVWXYZ234567
    ///
    /// Entropy bits per character: `5`
    case base32
    
    /// [RFC 4648](https://tools.ietf.org/html/rfc4648#section-7) base32 extended hex character set
    ///
    /// 0123456789abcdefghijklmnopqrstuv
    ///
    /// Entropy bits per character: `5`
    case base32Hex
    
    /// [RFC 4648](https://tools.ietf.org/html/rfc4648#section-7) base32 extended hex character set
    ///
    /// 0123456789ABCDEFGHIJKLMNOPQRSTUV
    ///
    /// Entropy bits per character: `5`
    case base32HexUpper
    
    /// [Crockford 32](https://www.crockford.com/base32.html)
    ///
    /// 0123456789ABCDEFGHJKMNPQRSTVWXYZ
    ///
    /// Entropy bits per character: `5`
    case crockford32
    
    /// Decimal digits
    ///
    /// 0123456789
    ///
    /// Entropy bits per character: `3.32`
    case decimal
    
    /// Hex lower case
    ///
    /// 0123456789abcdef
    ///
    /// Entropy bits per character: `4`
    case hex // "0123456789abcdef"
    
    /// Hex upper case
    ///
    /// 0123456789ABCDEF
    ///
    /// Entropy bits per character: `4`
    case hexUpper
    
    /// ASCII characters from `!` to `~`, minus backslash, backtick, single-quote and double-quote
    ///
    /// !#$%&()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_abcdefghijklmnopqrstuvwxyz{|}~
    ///
    /// Entropy bits per character: `6.49`
    case safeAscii
    
    /// Strings that don't look like English words and are easy to parse visually
    /// - remove all upper and lower case vowels (including y)
    /// - remove all numbers that look like letters
    /// - remove all letters that look like numbers
    /// - remove all letters that have poor distinction between upper and lower case values
    ///
    /// 2346789bdfghjmnpqrtBDFGHJLMNPQRT
    ///
    /// Entropy bits per character: `5`
    case safe32
    
    /// [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5) file system and URL safe character set
    ///
    /// ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_
    ///
    /// Entropy bits per character: `6`
    case safe64
    
    /// Symbols comprised of `safeAscii` characters not in `alphanum`
    ///
    /// !#$%&()*+,-./:;<=>?@[]^_{|}~
    ///
    /// Entropy bits per character: `4.81`
    case symbol

    /// Custom chars
    case custom(_ chars: String)
  }
}

extension Puid.Chars {
  static let maxCount = 256
  
  var bitsPerChar: Double {
    Puid.Util.log2i(string.count)
  }
  
  var bitShifts: [Puid.Bits.Shift] {
    let iBitsPerChar = Puid.Util.iCeil(Puid.Util.log2i(string.count))
    let baseValue = string.count % 2 == 0 ? string.count - 1 : string.count
    let baseShift: Puid.Bits.Shift = Puid.Bits.Shift(value: baseValue, shift: iBitsPerChar)
    
    if Puid.Util.isPow2(string.count) {
      return [baseShift]
    }
    
    return (2..<iBitsPerChar)
      .map { $0 }
      .reduce(into: [baseShift]) { acc, bit in
        if Puid.Util.isBitZero(n: baseValue, bit: bit) {
          let value = baseValue | (Puid.Util.iPow2(bit) - 1)
          let shift = iBitsPerChar - bit + 1
          acc.append(Puid.Bits.Shift(value: value, shift: shift))
        }
      }
  }

  /// The count of characters that comprise the `Puid.CharSet`
  var count: Int {
    string.count
  }
  
  /// Chars as string
  public var string: String {
    switch self {
      case .alpha:
        return Puid.Chars.Alpha
      case .alphaLower:
        return Puid.Chars.AlphaLower
      case .alphaUpper:
        return Puid.Chars.AlphaUpper
      case .alphaNum:
        return Puid.Chars.AlphaNum
      case .alphaNumLower:
        return Puid.Chars.AlphaNumLower
      case .alphaNumUpper:
        return Puid.Chars.AlphaNumUpper
      case .base32:
        return Puid.Chars.Base32
      case .base32Hex:
        return Puid.Chars.Base32Hex
      case .base32HexUpper:
        return Puid.Chars.Base32HexUpper
      case .crockford32:
        return Puid.Chars.Crockford32
      case .decimal:
        return Puid.Chars.DecimalDigits
      case .hex:
        return Puid.Chars.Hex
      case .hexUpper:
        return Puid.Chars.HexUpper
      case .safeAscii:
        return Puid.Chars.SafeAscii
      case .safe32:
        return Puid.Chars.Safe32
      case .safe64:
        return Puid.Chars.Safe64
      case .symbol:
        return Puid.Chars.Symbol
      case .custom(let chars):
        return chars
    }
  }
  
  func validate() throws {
    let chars = self.string
    guard 1 < chars.count else { throw PuidError.tooFewChars }
    guard chars.count <= Puid.Chars.maxCount else { throw PuidError.tooManyChars }
    guard chars.reduce(true, { $0 && Puid.Chars.valid(char: $1) }) else { throw PuidError.invalidChar }
    guard Set(chars).count == chars.count else { throw PuidError.charsNotUnique }
  }
}

extension Puid.Chars: Equatable {
  public static func ==(lhs: Puid.Chars, rhs: Puid.Chars) -> Bool {
    lhs.string == rhs.string
  }
}

extension Puid.Chars: CaseIterable {
  public static var allCases: [Puid.Chars] = [
    .alpha,
    .alphaLower,
    .alphaUpper,
    .alphaNum,
    .alphaNumLower,
    .alphaNumUpper,
    .base32,
    .base32Hex,
    .base32HexUpper,
    .crockford32,
    .decimal,
    .hex,
    .hexUpper,
    .safeAscii,
    .safe32,
    .safe64,
    .symbol]
}

extension Puid.Chars {
  static let AlphaLower = "abcdefghijklmnopqrstuvwxyz"
  static let AlphaUpper = AlphaLower.uppercased()
  static let Alpha = AlphaUpper + AlphaLower
  
  static let DecimalDigits = "0123456789"
  
  static let AlphaNum = Alpha + DecimalDigits
  static let AlphaNumLower = AlphaLower + DecimalDigits
  static let AlphaNumUpper = AlphaUpper + DecimalDigits
  
  static let Base32 = AlphaUpper + "234567"
  static let Base32Hex = DecimalDigits + "abcdefghijklmnopqrstuv"
  static let Base32HexUpper = Base32Hex.uppercased()
  
  static let Crockford32 = (DecimalDigits + AlphaUpper).filter { c in
    !"OLIU".contains(c)
  }
  
  static let Hex = DecimalDigits + "abcdef"
  static let HexUpper = Hex.uppercased()
  
  static let SafeAscii = "!#$%&()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_abcdefghijklmnopqrstuvwxyz{|}~"
  
  static let Safe32 = "2346789bdfghjmnpqrtBDFGHJLMNPQRT"
  
  static let Safe64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
  
  static let Symbol = "!#$%&()*+,-./:;<=>?@[]^_{|}~"
}

extension Puid.Chars {
  enum Encoding {
    case ascii
    case utf8
  }
  
  typealias EncodingByteCount = (encoding: Puid.Chars.Encoding, charsByteCount: Int)
  
  func encoding() -> EncodingByteCount {
    let charsByteCount = self.string.utf8.count
    let encoding: Encoding = self.count == charsByteCount ? .ascii : .utf8
    return (encoding: encoding, charsByteCount: charsByteCount)
  }
}

extension Puid.Chars {
  enum CodePoint: UInt32 {
    case bang = 0x0021
    case tilde = 0x007E
    case nonBreakingSpace = 0x00A0
  }
  
  static func codePoint(of char: Character) -> UInt32 {
    return char.unicodeScalars.first!.value
  }
  
  static func codePoint(of codePoint: CodePoint) -> UInt32 {
    codePoint.rawValue
  }
  
  /// Invalid characters are
  ///  - Less than bang
  ///  - Equal to backspace, backtick or single/double quotes
  ///  - Between tilde and inverse bang
  static func valid(char: Character) -> Bool {
    let charCodePoint = codePoint(of: char)
    
    guard codePoint(of: .bang) <= charCodePoint  else { return false }
    guard char != "\"" else { return false }
    guard char != "'" else { return false }
    guard char != "\\" else { return false }
    guard char != "`" else { return false }
    
    if (charCodePoint <= codePoint(of: .tilde)) { return true }
    if (charCodePoint < codePoint(of: .nonBreakingSpace)) { return false }
    
    return true
  }

}
