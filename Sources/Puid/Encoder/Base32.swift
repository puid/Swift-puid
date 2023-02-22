//
//  Puid.Encoder.Base32
//
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class Base32: Puid.Encoder.Ascii {
    override func map(_ puidNdx: PuidNdx) throws -> Puid.AsciiCode {
      switch puidNdx {
        case let value where puidNdx < 26:
          return Puid.Ascii.A.code + value
        case let value where puidNdx < 32:
          return Puid.Ascii.zero.code + value - 26 + 2
        default:
          throw PuidError.invalidEncoding(puidNdx: puidNdx)
      }
    }
  }
}
