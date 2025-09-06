//
//  PuidInitTest
//  
//  MIT License: See project LICENSE.txt
//

import XCTest
@testable import Puid

final class PuidInitTest: XCTestCase {

  func round2(_ x: Double) -> Double {
    round(x * 100) / 100.0
  }
  
  func assert(_ puid: Puid,
              bits: Double,
              bitsPerChar: Double,
              chars: Puid.Chars,
              ere: Double,
              length: Int) {
    let settings = puid.settings
    
    XCTAssertEqual(round2(settings.bits), bits)
    XCTAssertEqual(round2(settings.bitsPerChar), bitsPerChar)
    XCTAssertEqual(settings.chars, chars)
    XCTAssertEqual(round2(settings.ere), ere)
    XCTAssertEqual(settings.length, length)
    
    XCTAssertEqual(try puid.generate().count, length)
  }

  func testDefault() throws {
    let puid = try Puid()
    assert(puid,
           bits: 132.0,
           bitsPerChar: 6.0,
           chars: Puid.Chars.safe64,
           ere: 0.75,
           length: 22)
#if canImport(Darwin)
    XCTAssertEqual(puid.settings.entropy.source, "SecRandomCopyBytes")
#elseif os(Linux)
    XCTAssertEqual(puid.settings.entropy.source, "UInt8.random")
#endif

    XCTAssertNotNil(puid.description)
    XCTAssertNotNil(puid.settings.debugDescription)
  }
  
  func testBitsDefault() throws {
    assert(try Puid(bits: 66.6),
           bits: 72.0,
           bitsPerChar: 6.0,
           chars: Puid.Chars.safe64,
           ere: 0.75,
           length: 12)
  }

  func testBitsCharSet() throws {
    assert(try Puid(bits: 80, chars: Puid.Chars.alpha),
           bits: 85.51,
           bitsPerChar: 5.7,
           chars: Puid.Chars.alpha,
           ere: 0.71,
           length: 15)
  }

  func testBitsCustomAscii() throws {
    let chars = "thequickfox"
    assert(try Puid(bits: 100, chars: .custom(chars)),
           bits: 100.32,
           bitsPerChar: 3.46,
           chars: .custom(chars),
           ere: 0.43,
           length: 29)
  }

  func testBitsCustomUtf8() throws {
    let chars = "\u{1F98A}:théquiçkfox"
    assert(try Puid(bits: 64, chars: .custom(chars)),
           bits: 66.61,
           bitsPerChar: 3.7,
           chars: .custom(chars),
           ere: 0.33,
           length: 18)
  }

  func testTotalRiskDefault() throws {
    assert(try Puid(total: 1e7, risk: 1e12),
           bits: 90.0,
           bitsPerChar: 6.0,
           chars: Puid.Chars.safe64,
           ere: 0.75,
           length: 15)
  }

  func testTotalRiskCharSet() throws {
    assert(try Puid(total: 1e7, risk: 1e12, chars: Puid.Chars.alphaLower),
           bits: 89.31,
           bitsPerChar: 4.7,
           chars: Puid.Chars.alphaLower,
           ere: 0.59,
           length: 19)
  }

  func testTotalRiskAscii() throws {
    let chars = "dingoskyme"
    assert(try Puid(total: 1e9, risk: 1e15, chars: .custom(chars)),
           bits: 109.62,
           bitsPerChar: 3.32,
           chars: .custom(chars),
           ere: 0.42,
           length: 33)
  }

  func testTotalRiskUtf8() throws {
    let chars = "dîngøsky:\u{1F415}"

    assert(try Puid(total: 1e9, risk: 1e15, chars: .custom(chars)),
           bits: 109.62,
           bitsPerChar: 3.32,
           chars: .custom(chars),
           ere: 0.28,
           length: 33)
  }
  
  func testPrng() throws {
    let prngId = try Puid(entropy: .prng)
    assert(prngId,
           bits: 132.0,
           bitsPerChar: 6.0,
           chars: Puid.Chars.safe64,
           ere: 0.75,
           length: 22)
    XCTAssertEqual(prngId.settings.entropy.source, "UInt64.random")
    
    let totalRiskPrngId = try Puid(total: 1e7, risk: 1e12, chars: Puid.Chars.hex, entropy: .csprng)
    assert(totalRiskPrngId,
           bits: 88.0,
           bitsPerChar: 4.0,
           chars: Puid.Chars.hex,
           ere: 0.5,
           length: 22)
  }
  
  func testDefaultFixed() throws {
    let fixed = try Puid.Entropy.Fixed(hex: "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00")
    
    let defaultFixedId = try Puid(entropy: fixed)
    assert(defaultFixedId,
           bits: 132.0,
           bitsPerChar: 6.0,
           chars: Puid.Chars.safe64,
           ere: 0.75,
           length: 22)
    XCTAssertEqual(defaultFixedId.settings.entropy.source, "Fixed Bytes")
  }
  
  func testTotalRiskFixed() throws {
    let fixed = try Puid.Entropy.Fixed(hex: "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00")
    
    let totalRiskFixedId = try Puid(total: 1e7, risk: 1e12, chars: Puid.Chars.alphaLower, entropy: fixed)
    assert(totalRiskFixedId,
           bits: 89.31,
           bitsPerChar: 4.7,
           chars: Puid.Chars.alphaLower,
           ere: 0.59,
           length: 19)
  }

  func testEmptyFixed() throws {
    let emptyBytes = try Puid.Entropy.Fixed(hex: "")
    let emptyFixedId = try Puid(entropy: emptyBytes)
    XCTAssertThrowsError(try emptyFixedId.generate())

    do {
      let _ = try emptyFixedId.generate()
    } catch (let error as PuidError) {
      XCTAssertEqual(error.description, "Bytes are exhausted")
    }
  }

  func testUtil() throws {
    let fixed = try Puid.Entropy.Fixed(hex: "01 23 45 67")
    XCTAssertEqual(fixed.data.hex, "01 23 45 67")
    XCTAssertEqual(fixed.data.binary, "0000 0001 0010 0011 0100 0101 0110 0111")
    
    XCTAssertThrowsError(try Puid.Entropy.Fixed(hex: "32 1"))
  }

  func testAllCharSets() throws {
    for chars in Puid.Chars.allCases {
      XCTAssertNoThrow(try Puid(chars: chars))
    }
  }

  func assertThrows(_ chars: String, _: String) {
    XCTAssertThrowsError(try Puid(chars: .custom(chars)))
  }

  func testInvalidAscii() throws {
    assertThrows("dingo sky", "Should reject space")
    assertThrows("dingo\"sky", "Should reject double-quote")
    assertThrows("dingo\'sky", "Should reject single-quote")
    assertThrows("dingo\\sky", "Should reject backslash")
    assertThrows("dingo`sky", "Should reject backtick")
    assertThrows("dingo\u{0099}sky", "Should reject between tilde and inverted bang")
    
  }
  
  func testPuidErrors() throws {
    do {
      let _ = try Puid(chars: .custom("1"))
    } catch (let error as PuidError){
      XCTAssertEqual(error.description, "Require at least 2 characters")
    }

    do {
      let _ = try Puid(chars: .custom("dingodog"))
    } catch (let error as PuidError){
      XCTAssertEqual(error.description, "Characters not unique")
    }
    
    do {
      let _ = try Puid(chars: .custom("dingo`sky"))
    } catch (let error as PuidError){
      XCTAssertEqual(error.description, "Invalid character")
    }

    do {
      let _ = try Puid(chars: .custom("1"))
    } catch (let error as PuidError){
      XCTAssertEqual(error.description, "Require at least 2 characters")
    }

    let codePoints: [UInt32] =
    [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84,
     85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107,
     108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48,
     49, 50, 51, 52, 53, 54, 55, 56, 57, 45, 95, 256, 257, 258, 259, 260, 261, 262,
     263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278,
     279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294,
     295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310,
     311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326,
     327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342,
     343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358,
     359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374,
     375, 376, 377, 378, 379, 380, 381, 382, 383, 19904, 19905, 19906, 19907, 19908,
     19909, 19910, 19911, 19912, 19913, 19914, 19915, 19916, 19917, 19918, 19919,
     19920, 19921, 19922, 19923, 19924, 19925, 19926, 19927, 19928, 19929, 19930,
     19931, 19932, 19933, 19934, 19935, 19936, 19937, 19938, 19939, 19940, 19941,
     19942, 19943, 19944, 19945, 19946, 19947, 19948, 19949, 19950, 19951, 19952,
     19953, 19954, 19955, 19956, 19957, 19958, 19959, 19960, 19961, 19962, 19963,
     19964, 19965, 19966, 19967, 19999]
    
    XCTAssertEqual(codePoints.count, Puid.Chars.maxCount + 1)
    
    let utf8Codes = codePoints.map { UnicodeScalar($0)! }
    do {
      let _ = try Puid(chars: .custom(utf8Codes.string))
    } catch (let error as PuidError){
      XCTAssertEqual(error.description, "Exceed max of \(Puid.Chars.maxCount) characters")
    }
    
    let status: Int32 = 1
    let coverage = PuidError.bytesFailure(status: status)
    XCTAssertEqual(coverage.description, "Failed to generate bytes with status: \(status)")

    do {
      let tfId = try Puid(chars: .custom("TF"))
      let _ = try tfId.puidEncoder.encode([0,1,1,0,2,1])
    } catch (let error as PuidError){
      XCTAssertEqual(error.description, "Invalid encoding: puidNdx=2 not support by encoder")
    }
  }
}
