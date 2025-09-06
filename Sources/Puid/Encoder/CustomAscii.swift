//
//  Puid.Encoder.CustomAscii
//
//
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class CustomAscii: Puid.Encoder.Ascii {
    let asciiCodes: [Puid.AsciiCode]

    init(chars: String) {
      asciiCodes = chars.reduce(into: [Puid.AsciiCode]()) { codes, char in
        codes.append(char.asciiValue!)
      }
    }

    override func map(_ puidNdx: PuidNdx) throws -> Puid.AsciiCode {
      switch puidNdx {
      case let value where puidNdx < asciiCodes.count:
        return asciiCodes[Int(value)]
      default:
        throw PuidError.invalidEncoding(puidNdx: puidNdx)
      }
    }
  }
}
