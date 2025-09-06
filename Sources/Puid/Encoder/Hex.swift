//
//  Puid.Encoder.Hex
//
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class Hex: Puid.Encoder.Ascii {
    let alpha: Puid.AsciiCode

    init(case encoderCase: Puid.Encoder.Ascii.Case = .lower) {
      alpha = encoderCase.alpha()
    }

    override func map(_ puidNdx: PuidNdx) throws -> Puid.AsciiCode {
      switch puidNdx {
      case let value where puidNdx < 10:
        return Puid.Ascii.zero.code + value
      case let value where puidNdx < 16:
        return alpha + value - 10
      default:
        throw PuidError.invalidEncoding(puidNdx: puidNdx)
      }
    }
  }
}
