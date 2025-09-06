//
//  Puid.Encoder.Ascii
//
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class Ascii: PuidAsciiMapProtocol, PuidEncoderProtocol {
    func map(_ code: PuidNdx) throws -> Puid.AsciiCode {
      throw PuidError.invalidEncoder
    }

    func encode(_ ndxs: PuidNdxs) throws -> String {
      String(bytes: try ndxs.map { try map($0) }, encoding: .ascii)!
    }
  }
}

extension Puid.Encoder.Ascii {
  enum Case {
    case lower
    case upper

    func alpha() -> Puid.AsciiCode {
      switch self {
      case .lower:
        return Puid.Ascii.a.code
      case .upper:
        return Puid.Ascii.A.code
      }
    }
  }
}
