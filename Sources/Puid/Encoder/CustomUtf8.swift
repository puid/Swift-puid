//
//  Puid.Encoder.CustomUtf8
//
//
//  MIT License: See project LICENSE.txt
//

extension Puid.Encoder {
  class CustomUtf8: Puid.Encoder.Utf8 {
    let utf8Codes: [Utf8Code]

    init(chars: String) {
      utf8Codes = chars.unicodeScalars
        .reduce(into: [Utf8Code]()) { codes, utf8Scalar in
          codes.append(utf8Scalar.value)
        }
    }

    override func map(_ puidNdx: PuidNdx) throws -> Utf8Code {
      switch puidNdx {
      case let value where puidNdx < utf8Codes.count:
        return utf8Codes[Int(value)]
      default:
        throw PuidError.invalidEncoding(puidNdx: puidNdx)
      }
    }
  }
}
