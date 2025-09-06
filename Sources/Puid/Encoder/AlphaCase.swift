//
//  Puid.Encoder.AlphaCase
//
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class AlphaCase: Puid.Encoder.Ascii {
    let alpha: Puid.AsciiCode

    init(case encoderCase: Puid.Encoder.Ascii.Case = .lower) {
      alpha = encoderCase.alpha()
    }

    override func map(_ puidNdx: PuidNdx) throws -> Puid.AsciiCode {
      switch puidNdx {
      case let value where puidNdx < 26:
        return alpha + value
      default:
        throw PuidError.invalidEncoding(puidNdx: puidNdx)
      }
    }
  }
}
