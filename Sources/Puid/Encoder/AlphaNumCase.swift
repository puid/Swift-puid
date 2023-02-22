//
//  Puid.Encoder.AlphaNumCase
//  
//
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class AlphaNumCase: Puid.Encoder.Ascii {
    let alpha: Puid.AsciiCode
    
    init(case encoderCase: Puid.Encoder.Ascii.Case = .lower) {
      alpha = encoderCase.alpha()
    }
    
    override func map(_ puidNdx: PuidNdx) throws -> Puid.AsciiCode {
      switch puidNdx {
        case let value where puidNdx < 26:
          return alpha + value
        case let value where puidNdx < 36:
          return Puid.Ascii.zero.code + value - 26
        default:
          throw PuidError.invalidEncoding(puidNdx: puidNdx)
      }
    }
  }
}
