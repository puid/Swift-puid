//
//  Puid.Encoder.Crockford32.swift
//  
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class Crockford32: Puid.Encoder.Ascii {
    override func map(_ puidNdx: PuidNdx) throws -> Puid.AsciiCode {
      switch puidNdx {
        case let value where puidNdx < 10:
          return Puid.Ascii.zero.code + value
        case let value where puidNdx < 18:
          return Puid.Ascii.A.code + value - 10
        case let value where puidNdx < 20:
          return Puid.Ascii.J.code + value - 18
        case let value where puidNdx < 22:
          return Puid.Ascii.M.code + value - 20
        case let value where puidNdx < 27:
          return Puid.Ascii.P.code + value - 22
        case let value where puidNdx < 32:
          return Puid.Ascii.V.code + value - 27
        default:
          throw PuidError.invalidEncoding(puidNdx: puidNdx)
      }
    }
  }
}
