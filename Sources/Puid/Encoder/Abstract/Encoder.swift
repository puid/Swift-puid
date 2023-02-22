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
        case .base32:
          return Puid.Encoder.Base32()
        case .base32Hex:
          return Puid.Encoder.Base32HexCase(case: .lower)
        case .base32HexUpper:
          return Puid.Encoder.Base32HexCase(case: .upper)
        case .crockford32:
          return Puid.Encoder.Crockford32()
        case .decimal:
          return Puid.Encoder.Decimal()
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
        case .symbol:
          return Puid.Encoder.Symbol()
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
