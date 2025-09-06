//
//  Puid.Encoder.Decimal
//
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class Decimal: Puid.Encoder.Ascii {
    override func map(_ puidNdx: PuidNdx) throws -> Puid.AsciiCode {
      switch puidNdx {
      case let value where puidNdx < 10:
        return Puid.Ascii.zero.code + value
      default:
        throw PuidError.invalidEncoding(puidNdx: puidNdx)
      }
    }
  }
}
