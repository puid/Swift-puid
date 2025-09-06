//
//  Puid.Encoder.SafeAscii
//
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class SafeAscii: Puid.Encoder.Ascii {
    override func map(_ puidNdx: PuidNdx) throws -> Puid.AsciiCode {
      switch puidNdx {
      case 0:
        return Puid.Ascii.bang.code
      case let value where puidNdx < 5:
        return Puid.Ascii.ampersand.code + value - 4
      case let value where puidNdx < 57:
        return Puid.Ascii.openSquareBracket.code + value - 56
      case let value where puidNdx < 60:
        return Puid.Ascii.underscore.code + value - 59
      case let value where puidNdx < 90:
        return Puid.Ascii.a.code + value - 60
      default:
        throw PuidError.invalidEncoding(puidNdx: puidNdx)
      }
    }
  }
}
