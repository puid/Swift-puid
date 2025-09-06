//
//  Puid.Encoder
//  
//  MIT License: See project LICENSE.txt
//

extension Puid {
  class Encoder {
    static func encoder(for chars: Puid.Chars) throws -> PuidEncoderProtocol {
      switch chars {
        case .alpha:
          return Puid.Encoder.Alpha()
        case .alphaLower:
          return Puid.Encoder.AlphaCase(case: .lower)
        case .alphaUpper:
          return Puid.Encoder.AlphaCase(case: .upper)
        case .alphaNum:
          return Puid.Encoder.AlphaNum()
        case .alphaNumLower:
          return Puid.Encoder.AlphaNumCase(case: .lower)
        case .alphaNumUpper:
          return Puid.Encoder.AlphaNumCase(case: .upper)
        case .base16:
          return Puid.Encoder.Hex(case: .upper)
        case .base32:
          return Puid.Encoder.Base32()
        case .base32Hex:
          return Puid.Encoder.Base32HexCase(case: .lower)
        case .base32HexUpper:
          return Puid.Encoder.Base32HexCase(case: .upper)
        case .base36:
          return Puid.Encoder.CustomAscii(chars: Puid.Chars.Base36)
        case .base36Upper:
          return Puid.Encoder.CustomAscii(chars: Puid.Chars.Base36Upper)
        case .base58:
          return Puid.Encoder.CustomAscii(chars: Puid.Chars.Base58)
        case .base62:
          return Puid.Encoder.AlphaNum()
        case .crockford32:
          return Puid.Encoder.Crockford32()
        case .decimal:
          return Puid.Encoder.Decimal()
        case .bech32:
          return Puid.Encoder.CustomAscii(chars: Puid.Chars.Bech32)
        case .boolean:
          return Puid.Encoder.CustomAscii(chars: Puid.Chars.Boolean)
        case .dna:
          return Puid.Encoder.CustomAscii(chars: Puid.Chars.DNA)
        case .geohash:
          return Puid.Encoder.CustomAscii(chars: Puid.Chars.Geohash)
        case .hex:
          return Puid.Encoder.Hex(case: .lower)
        case .hexUpper:
          return Puid.Encoder.Hex(case: .upper)
        case .safeAscii:
          return Puid.Encoder.SafeAscii()
        case .safe32:
          return Puid.Encoder.Safe32()
        case .safe64:
          return Puid.Encoder.Safe64()
        case .urlSafe:
          return Puid.Encoder.CustomAscii(chars: Puid.Chars.UrlSafe)
        case .symbol:
          return Puid.Encoder.Symbol()
        case .wordSafe32:
          return Puid.Encoder.CustomAscii(chars: Puid.Chars.WordSafe32)
        case .zBase32:
          return Puid.Encoder.CustomAscii(chars: Puid.Chars.ZBase32)
        case .custom(let chars):
          let isAscii = chars.reduce(true) { valid, char in
            return valid && char.isASCII
          }
          if isAscii {
            return Puid.Encoder.CustomAscii(chars: chars)
          }
          return Puid.Encoder.CustomUtf8(chars: chars)
      }
    }
  }
}
