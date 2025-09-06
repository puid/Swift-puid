//
//  Puid.Encoder.Symbol
//
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class Symbol: Puid.Encoder.Ascii {
    override func map(_ puidNdx: PuidNdx) throws -> Puid.AsciiCode {
      switch puidNdx {
      case 0:
        return Puid.Ascii.bang.code
      case let value where puidNdx < 5:
        return Puid.Ascii.hashTag.code + value - 1
      case let value where puidNdx < 13:
        return Puid.Ascii.openParen.code + value - 5
      case let value where puidNdx < 20:
        return Puid.Ascii.colon.code + value - 13
      case 20:
        return Puid.Ascii.openSquareBracket.code
      case let value where puidNdx < 24:
        return Puid.Ascii.closeSquareBracket.code + value - 21
      case let value where puidNdx < 28:
        return Puid.Ascii.openCurlyBracket.code + value - 24
      default:
        throw PuidError.invalidEncoding(puidNdx: puidNdx)
      }
    }
  }
}
