//
//  Puid.Encoder.Utf8
//
//  MIT License: See project LICENSE.txt
//

typealias Utf8Code = UInt32

extension Sequence where Element == UnicodeScalar {
  var string: String { .init(String.UnicodeScalarView(self)) }
}

extension Puid.Encoder {
  class Utf8: PuidUtf8MapProtocol, PuidEncoderProtocol {
    func map(_ code: PuidNdx) throws -> Utf8Code {
      throw PuidError.invalidEncoder
    }
    
    func encode(_ ndxs: PuidNdxs) throws -> String {
      let utf8Codes = try ndxs.map { try UnicodeScalar(map($0))! }
      return utf8Codes.string
    }
  }
}
