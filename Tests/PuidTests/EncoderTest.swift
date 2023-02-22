//
//  EncoderTest
//
//  MIT License: See project LICENSE.txt
//

import XCTest
@testable import Puid

final class EncoderTest: XCTestCase {
  
  func encodedChars(chars: Puid.Chars) throws -> String {
    let encoder = try Puid.Encoder.encoder(for: chars)
    XCTAssertThrowsError(try encoder.encode([PuidNdx(chars.count)]))
    let ndxs = (PuidNdx(0)..<PuidNdx(chars.count)).map { $0 }
    return try encoder.encode(ndxs)
  }
  
  func testAllCharSetEncoders() throws {
    for chars in Puid.Chars.allCases {
      let encodedChars = try encodedChars(chars: chars)
      XCTAssertEqual(encodedChars, chars.string)
    }
  }
  
  func testCustomAscii() throws {
    let chars = Puid.Chars.custom("dingosky")
    let encodedChars = try encodedChars(chars: chars)
    XCTAssertEqual(encodedChars, chars.string)
  }

  func testCutomUtf8() throws {
    let chars = Puid.Chars.custom("dîngøsky:\u{1F415}")
    let encodedChars = try encodedChars(chars: chars)
    XCTAssertEqual(encodedChars, chars.string)
  }
  
  func testInvalidEncoders() throws {
    class InvalidAsciiEncoder: Puid.Encoder.Ascii {}
    let invalidAsciiEncoder = InvalidAsciiEncoder()
    do {
      let _ = try invalidAsciiEncoder.map(0)
    } catch (let error as PuidError){
      XCTAssertEqual(error.description, "Invalid encoder: override Encoder.encode method")
    }

    class InvalidUtf8Encoder: Puid.Encoder.Utf8 {}
    let invalidUtf8Encoder = InvalidUtf8Encoder()
    do {
      let _ = try invalidUtf8Encoder.map(0)
    } catch (let error as PuidError){
      XCTAssertEqual(error.description, "Invalid encoder: override Encoder.encode method")
    }
  }
}
