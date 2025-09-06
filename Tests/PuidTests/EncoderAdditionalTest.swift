//
//  EncoderAdditionalTest
//
//  MIT License: See project LICENSE.txt
//

import XCTest
@testable import Puid

final class EncoderAdditionalTest: XCTestCase {
  private func encoded(_ chars: Puid.Chars) throws -> String {
    let encoder = try Puid.Encoder.encoder(for: chars)
    let ndxs = (0..<chars.count).map { PuidNdx($0) }
    return try encoder.encode(ndxs)
  }

  func testBase16Encoding() throws {
    let s = try encoded(.base16)
    XCTAssertEqual(s, "0123456789ABCDEF")
  }

  func testBase36Encoding() throws {
    let s = try encoded(.base36)
    XCTAssertEqual(s, "0123456789abcdefghijklmnopqrstuvwxyz")
    let su = try encoded(.base36Upper)
    XCTAssertEqual(su, "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")
  }

  func testBase58Encoding() throws {
    let s = try encoded(.base58)
    XCTAssertEqual(s, "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz")
  }

  func testBase62Encoding() throws {
    let s = try encoded(.base62)
    XCTAssertEqual(s, Puid.Chars.alphaNum.string)
  }

  func testBech32Encoding() throws {
    let s = try encoded(.bech32)
    XCTAssertEqual(s, "023456789acdefghjklmnpqrstuvwxyz")
  }

  func testUrlSafeEncoding() throws {
    let s = try encoded(.urlSafe)
    XCTAssertEqual(s, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
  }
}

