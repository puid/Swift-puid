//
//  Puid.Encoder.Safe32
//
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class Safe32: Puid.Encoder.Ascii {
    override func map(_ puidNdx: PuidNdx) throws -> Puid.AsciiCode {
      switch puidNdx {
      case let value where puidNdx < 3:
        return Puid.Ascii.two.code + value
      case let value where puidNdx < 7:
        return Puid.Ascii.six.code + value - 3
      case 7:
        return Puid.Ascii.b.code
      case 8:
        return Puid.Ascii.d.code
      case let value where puidNdx < 12:
        return Puid.Ascii.f.code + value - 9
      case 12:
        return Puid.Ascii.j.code
      case let value where puidNdx < 15:
        return Puid.Ascii.m.code + value - 13
      case let value where puidNdx < 18:
        return Puid.Ascii.p.code + value - 15
      case 18:
        return Puid.Ascii.t.code
      case 19:
        return Puid.Ascii.B.code
      case 20:
        return Puid.Ascii.D.code
      case let value where puidNdx < 24:
        return Puid.Ascii.F.code + value - 21
      case 24:
        return Puid.Ascii.J.code
      case let value where puidNdx < 28:
        return Puid.Ascii.L.code + value - 25
      case let value where puidNdx < 31:
        return Puid.Ascii.P.code + value - 28
      case 31:
        return Puid.Ascii.T.code
      default:
        throw PuidError.invalidEncoding(puidNdx: puidNdx)
      }
    }
  }
}
