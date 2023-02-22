//
//  Puid.Encoder.Safe64
//
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class Safe64: Puid.Encoder.Ascii {
    override func map(_ puidNdx: PuidNdx) throws -> Puid.AsciiCode {
      switch puidNdx {
        case let value where puidNdx < 26:
          return Puid.Ascii.A.code + value
        case let value where puidNdx < 52:
          return Puid.Ascii.a.code + value - 26
        case let value where puidNdx < 62:
          return Puid.Ascii.zero.code + value - 52
        case 62:
          return Puid.Ascii.dash.code
        case 63:
          return Puid.Ascii.underscore.code
        default:
          throw PuidError.invalidEncoding(puidNdx: puidNdx)
      }
    }
  }
}
