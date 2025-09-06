//
//  EncodeDecodeTest.swift
//
//  MIT License: See project LICENSE.txt
//

import XCTest

@testable import Puid

final class EncodeDecodeTest: XCTestCase {
  func testEncodeAlphaLowerFromBits() throws {
    let puid = try Puid(bits: 55, chars: .alphaLower)
    let bytes: [UInt8] = [0x8D, 0x8A, 0x02, 0xA8, 0x07, 0x0B, 0x0D, 0x00]
    let data = Data(bytes)
    let s = try puid.encode(bits: data)
    XCTAssertEqual(s, "rwfafkahbmgq")
  }

  func testEncodeFailsOnInvalidIndex() throws {
    let puid = try Puid(bits: 34, chars: .alpha)
    let expectedBytes = 5  // ceil( (ceil(5.7)*len)/8 ) with len=ceil(34/5.7)=6 -> bits=36 -> bytes=5
    var bytes = [UInt8](repeating: 0, count: expectedBytes)
    bytes[0] = 0xFC  // 11111100 -> first 6-bit value 63 > 51 (alpha has 52 chars)
    let data = Data(bytes)
    XCTAssertThrowsError(try puid.encode(bits: data)) { error in
      guard let e = error as? PuidError, case .invalidEncoding = e else {
        XCTFail("Expected invalidEncoding error")
        return
      }
    }
  }

  func testDecodeEncodeRoundTripHex() throws {
    let hex = try Puid(bits: 128, chars: .hex)
    let id = try hex.generate()
    let bits = try hex.decode(id)
    let again = try hex.encode(bits: bits)
    XCTAssertEqual(again, id)
  }

  func testDecodeEncodeRoundTripSafeAscii() throws {
    let ascii = try Puid(bits: 128, chars: .safeAscii)
    let id = try ascii.generate()
    let bits = try ascii.decode(id)
    let again = try ascii.encode(bits: bits)
    XCTAssertEqual(again, id)
  }

  func testDecodeUnsupportedForUtf8() throws {
    let unicode = try Puid(bits: 50, chars: .custom("dîngøsky"))
    XCTAssertThrowsError(try unicode.decode("kîy")) { error in
      guard let e = error as? PuidError, case .invalidEncoder = e else {
        XCTFail("Expected invalidEncoder error")
        return
      }
    }
  }

  func testDecodeLengthMismatch() throws {
    let puid = try Puid(bits: 64, chars: .alpha)
    let id = try puid.generate()
    let short = String(id.dropFirst())
    XCTAssertThrowsError(try puid.decode(short)) { error in
      guard let e = error as? PuidError, case .dataSize = e else {
        XCTFail("Expected dataSize error")
        return
      }
    }
  }
}
